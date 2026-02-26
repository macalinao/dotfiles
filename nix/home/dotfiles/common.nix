{
  config,
  pkgs,
  lib,
  systemConfig,
  ...
}:

let
  static = ../static;
  claude-settings = ../../../config/claude/settings.json;
in
lib.mkMerge [
  {
    home.file.".vimrc".source = "${static}/vimrc";
    home.file.".claude/settings.json".source = claude-settings;
  }
  # Generate .claude-N/settings.json and .claude-N/plans for instances 2 through claudeInstances
  (lib.mkMerge (
    builtins.genList (
      i:
      let
        n = toString (i + 2);
      in
      {
        home.file.".claude-${n}/settings.json".source = claude-settings;
        home.file.".claude-${n}/plans".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
      }
    ) (systemConfig.igm.claudeInstances - 1)
  ))
  (lib.mkIf pkgs.stdenv.isLinux {
    home.file.".xscreensaver".source = "${static}/xscreensaver";

    home.file.".config/fcitx" = {
      source = "${static}/fcitx";
      recursive = true;
    };
  })
  (lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".yabairc".source = "${static}/yabairc";
    home.file.".skhdrc".source = "${static}/skhdrc";
  })
]
