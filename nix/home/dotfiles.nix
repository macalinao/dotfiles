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

  # All Claude config dirs: .claude plus .claude-2 .. .claude-N.
  claudeDirs = [
    ".claude"
  ]
  ++ builtins.genList (i: ".claude-${toString (i + 2)}") (config.igm.claudeInstances - 1);
in
{
  home.file = {
    ".vimrc".source = "${static}/vimrc";
  }
  // (builtins.listToAttrs (
    builtins.genList (
      i:
      let
        n = toString (i + 2);
      in
      {
        name = ".claude-${n}/plans";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
        };
      }
    ) (config.igm.claudeInstances - 1)
  ))
  // (lib.optionalAttrs pkgs.stdenv.isLinux {
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
