{ config, pkgs, ... }:

let private-secrets = "${config.home.homeDirectory}/private_secrets/dotfiles";
in {
  home.file.".aws" = {
    source = "${private-secrets}/aws";
    recursive = true;
  };

  home.file.".npmrc".source = "${private-secrets}/npmrc";
}
