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
lib.mkMerge [
  {
    home.file.".vimrc".source = "${static}/vimrc";
    home.file.".claude/settings.json".source = claude-settings;
    home.file.".claude-2/settings.json".source = claude-settings;
    home.file.".claude-3/settings.json".source = claude-settings;
    home.file.".claude-4/settings.json".source = claude-settings;
    home.file.".claude-5/settings.json".source = claude-settings;

    # Share plans across all claude config dirs
    home.file.".claude-2/plans".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
    home.file.".claude-3/plans".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
    home.file.".claude-4/plans".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
    home.file.".claude-5/plans".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.claude/plans";
  }
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
