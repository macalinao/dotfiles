{
  pkgs,
  lib,
  ...
}:

let
  static = ../static;
in
lib.mkMerge [
  { home.file.".vimrc".source = "${static}/vimrc"; }
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
