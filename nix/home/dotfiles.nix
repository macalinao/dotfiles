{
  config,
  pkgs,
  lib,
  ...
}:

let
  static = ./static;

  # Canonical Claude Code settings, used as the seed for a fresh install.
  #
  # NOTE: this is intentionally NOT symlinked into place. Claude Code
  # rewrites ~/.claude/settings.json at runtime (toggling plugins, changing
  # model, etc.). A read-only Nix store symlink can't be written through, so
  # Claude replaces it with a plain mutable file, which then silently drifts
  # from the repo — including dropping includeCoAuthoredBy and bringing the
  # "Co-Authored-By: Claude" commit trailer back. Instead we seed the file on
  # first install and re-assert includeCoAuthoredBy=false on every activation
  # (see home.activation.claudeSettings below), while preserving whatever
  # Claude has written in between.
  claude-settings = ../../config/claude/settings.json;

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

  # Seed Claude settings on fresh installs and always force the co-author
  # trailer off, without clobbering runtime changes Claude makes to the file.
  # Runs after the write boundary so home.file linking has already happened.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    seed=${claude-settings}
    jq=${pkgs.jq}/bin/jq

    # Anchor for the shared plans symlinks above. Without this the
    # .claude-N/plans links dangle (they did for the whole life of the
    # old ~/.claude/plans anchor, which was never created).
    $DRY_RUN_CMD mkdir -p "$HOME/.claude-1/plans"
    for dir in ${lib.concatStringsSep " " claudeDirs}; do
      target="$HOME/$dir/settings.json"
      tmp="$(mktemp)"
      # Existing file: keep everything Claude wrote, only force the key.
      # Fresh install: seed the whole file from the repo.
      if [ -e "$target" ]; then src="$target"; else src="$seed"; fi
      if "$jq" '.includeCoAuthoredBy = false' "$src" > "$tmp" && [ -s "$tmp" ]; then
        if [ ! -e "$target" ] || ! cmp -s "$tmp" "$target"; then
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
