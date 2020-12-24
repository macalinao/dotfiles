{ config, pkgs, lib }:

let dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
in lib.mkMerge [
  {
    home.file.".vimrc".source = "${dotfiles}/vimrc";
    home.file.".Brewfile".source = "${dotfiles}/Brewfile";
  }
  (lib.mkIf pkgs.stdenv.isLinux {
    home.file.".xscreensaver".source = "${dotfiles}/xscreensaver";

    home.file.".config/fcitx" = {
      source = "${dotfiles}/fcitx";
      recursive = true;
    };
  })
]
