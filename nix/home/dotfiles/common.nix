{ config, pkgs, lib }:

let dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
in lib.mkMerge [
  {
    home.file.".gitconfig".source = "${dotfiles}/gitconfig";
    home.file.".vimrc".source = "${dotfiles}/vimrc";
  }
  (lib.mkIf pkgs.stdenv.isLinux {
    home.file.".xscreensaver".source = "${dotfiles}/xscreensaver";

    home.file.".config/fcitx" = {
      source = "${dotfiles}/fcitx";
      recursive = true;
    };
  })
]
