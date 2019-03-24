{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
in {
  home.file.".gitconfig".source = "${dotfiles}/gitconfig";
  home.file.".spacemacs".source = "${dotfiles}/spacemacs";

  home.file.".vimrc".source = "${dotfiles}/vimrc";
  home.file.".vim" = {
    source = "${dotfiles}/vim";
    recursive = true;
  };

  home.file.".sbt" = {
    source = "${dotfiles}/sbt";
    recursive = true;
  };
}
