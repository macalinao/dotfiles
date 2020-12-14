{ config, pkgs, ... }:

let private-secrets = "${config.home.homeDirectory}/private_secrets/dotfiles";
in {
  home.file.".sbt/1.0/repositories" = {
    source = "${private-secrets}/sbt/repositories";
  };

  home.file.".sbt/1.0/.credentials" = {
    source = "${private-secrets}/sbt/credentials";
  };

  home.file.".sbt/1.0/sonatype.sbt".source = "${private-secrets}/sonatype.sbt";

  home.file.".config/coursier" = {
    source = "${private-secrets}/coursier";
    recursive = true;
  };

  home.file.".aws" = {
    source = "${private-secrets}/aws";
    recursive = true;
  };

  # home.file.".kube" = {
  #   source = "${private-secrets}/kube";
  #   recursive = true;
  # };

  # home.file.".jx" = {
  #   source = "${private-secrets}/jx";
  #   recursive = true;
  # };

  home.file.".npmrc".source = "${private-secrets}/npmrc";
}
