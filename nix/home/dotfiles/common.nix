{ config, pkgs, lib }:

let dotfiles = ../../../dotfiles;
in lib.mkMerge [
  { home.file.".vimrc".source = "${dotfiles}/vimrc"; }
  (lib.mkIf pkgs.stdenv.isLinux {
    home.file.".xscreensaver".source = "${dotfiles}/xscreensaver";

    home.file.".config/fcitx" = {
      source = "${dotfiles}/fcitx";
      recursive = true;
    };
  })
]
