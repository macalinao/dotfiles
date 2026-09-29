{
  config,
  pkgs,
  lib,
  ...
}:

let
  static = ./static;

  # Canonical Claude Code settings, and the JSON seed rendered from them.
  #
  # NOTE: the seed is intentionally NOT symlinked into place. Claude Code
  # rewrites ~/.claude/settings.json at runtime (toggling plugins, changing
  # model, etc.). A read-only Nix store symlink can't be written through, so
  # Claude replaces it with a plain mutable file, which then silently drifts
  # from the repo — including dropping includeCoAuthoredBy and bringing the
  # "Co-Authored-By: Claude" commit trailer back. Instead we seed the file on
  # first install and re-assert `forcedSettings` on every activation (see
  # home.activation.claudeSettings below), while preserving whatever
  # Claude has written in between.
  claudeSettings = import ./claude-settings.nix;
  claude-settings = (pkgs.formats.json { }).generate "claude-settings.json" claudeSettings;

  # Settings re-asserted on every activation, not just seeded.
  #
  # Seeding alone is not enough: the seed is only consulted when
  # settings.json does not exist, so anything Claude rewrites afterwards
  # drifts permanently. That is how one machine ended up with six
  # different settings.json variants across its instance dirs.
  #
  # So the default is now inverted: everything in claude-settings.nix is
  # forced, and only the keys listed in `runtimeOwned` are left mutable.
  # Deriving both the seed and this from one attrset keeps a single source of
  # truth -- a key added there is policy on every instance without also
  # having to be restated here.
  #
  # `runtimeOwned` is the escape hatch for keys Claude Code writes from its
  # own UI, where forcing would silently revert a deliberate choice on the
  # next switch:
  #   model, theme      -- /model and /theme
  #   enabledPlugins    -- /plugin (chrome-devtools-mcp and playwright are
  #                        currently toggled off on this machine; forcing
  #                        the attrset's `true` would turn them back on)
  # These stay in the seed, which is a starting point rather than a policy.
  #
  # Host-specific settings whose value depends on which user is running
  # (per-user storage paths and extra readable directories) are not in the
  # canonical attrset at all. This repo is shared across users, so a literal
  # path would point all of them at one user's location; those keys are
  # forced by the private host module that knows the mapping. The jq merge
  # below is a deep merge, so forcing `permissions` here still leaves the
  # private module's `permissions.additionalDirectories` untouched.
  runtimeOwned = [
    "model"
    "theme"
    "enabledPlugins"
  ];

  forcedSettings = removeAttrs claudeSettings runtimeOwned;

  # All Claude config dirs: .claude-1 .. .claude-N. Instance 1 is the one
  # bare `claude` uses -- headless.nix exports CLAUDE_CONFIG_DIR=~/.claude-1
  # so no session ever falls back to ~/.claude. Keeping every instance in
  # the same shape means nothing has to special-case the default scope.
  claudeDirs = builtins.genList (i: ".claude-${toString (i + 1)}") config.igm.claudeInstances;
in
{
  home.file = {
    ".vimrc".source = "${static}/vimrc";
  }
  # Plans are shared across instances: .claude-1/plans is the anchor and
  # every other instance symlinks to it, so a plan written under one
  # instance is visible from all of them. Instance 1 owns the real
  # directory and so is skipped here (it must not symlink to itself); the
  # activation below creates it.
  // (builtins.listToAttrs (
    builtins.genList (
      i:
      let
        n = toString (i + 2);
      in
      {
        name = ".claude-${n}/plans";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude-1/plans";
        };
      }
    ) (config.igm.claudeInstances - 1)
  ))
  // (lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    ".xscreensaver".source = "${static}/xscreensaver";
    ".config/fcitx" = {
      source = "${static}/fcitx";
      recursive = true;
    };
  });

  # Seed Claude settings on fresh installs and re-assert `forcedSettings`
  # every time, without clobbering runtime changes Claude makes to the file.
  # Runs after the write boundary so home.file linking has already happened.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    seed=${claude-settings}
    jq=${pkgs.jq}/bin/jq
    forced=${lib.escapeShellArg (builtins.toJSON forcedSettings)}

    # Anchor for the shared plans symlinks above. Without this the
    # .claude-N/plans links dangle (they did for the whole life of the
    # old ~/.claude/plans anchor, which was never created).
    $DRY_RUN_CMD mkdir -p "$HOME/.claude-1/plans"
    for dir in ${lib.concatStringsSep " " claudeDirs}; do
      target="$HOME/$dir/settings.json"
      tmp="$(mktemp)"
      # Existing file: keep everything Claude wrote, re-assert the forced
      # keys over it. Fresh install: seed the whole file from the repo, with
      # the same forced keys merged on top, so a forced key lands in the
      # very first settings.json too.
      if [ -e "$target" ]; then src="$target"; else src="$seed"; fi
      # `*` deep-merges, so nested keys Claude owns survive alongside
      # the forced ones.
      if "$jq" --argjson forced "$forced" '. * $forced' "$src" > "$tmp" && [ -s "$tmp" ]; then
        # Write only when the merge changes a *value*. This compares parsed
        # JSON rather than bytes, because Nix attrsets are unordered: the
        # forced blob's object keys come out alphabetical ({"hooks",
        # "matcher"}) while Claude Code writes its own order ({"matcher",
        # "hooks"}). A byte comparison rewrites all ten settings.json on every
        # activation that follows a Claude-side write, without changing a
        # single setting. jq's `==` ignores object key order; a malformed
        # target makes jq fail, which counts as different and heals the file.
        if [ ! -e "$target" ] || ! "$jq" -e --slurpfile new "$tmp" '. == $new[0]' "$target" >/dev/null; then
          $DRY_RUN_CMD mkdir -p "$HOME/$dir"
          $DRY_RUN_CMD install -m 0600 "$tmp" "$target"
        fi
      else
        echo "claudeSettings: jq failed for $target, leaving unchanged" >&2
      fi
      rm -f "$tmp"
    done
  '';
}
