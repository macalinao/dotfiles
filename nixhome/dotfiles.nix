{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
in {
  home.file.".sbt/1.0/plugins/plugins.sbt".source = "${dotfiles}/sbt/1.0/plugins/plugins.sbt";
}
