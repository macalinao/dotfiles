{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
in {
  home.file.".sbt" = {
    source = "${dotfiles}/sbt";
    recursive = true;
  };
}
