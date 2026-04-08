{
  config,
  pkgs,
  lib,
  ...
}:

let
  static = ../static;
  claude-settings = ../../../config/claude/settings.json;
in
{
  home.file = {
    ".vimrc".source = "${static}/vimrc";
    ".claude/settings.json".source = claude-settings;
  }
  // (builtins.listToAttrs (
    builtins.concatLists (
      builtins.genList (
        i:
        let
          n = toString (i + 2);
        in
        [
          {
            name = ".claude-${n}/settings.json";
            value = {
              source = claude-settings;
            };
          }
          {
            name = ".claude-${n}/plans";
            value = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
            };
          }
        ]
      ) (config.igm.claudeInstances - 1)
    )
  ))
  // (lib.optionalAttrs pkgs.stdenv.isLinux {
    ".xscreensaver".source = "${static}/xscreensaver";
    ".config/fcitx" = {
      source = "${static}/fcitx";
      recursive = true;
    };
  })
  // (lib.optionalAttrs pkgs.stdenv.isDarwin {
    ".skhdrc".source = "${static}/skhdrc";
  });
}
