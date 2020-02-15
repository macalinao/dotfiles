{ config, pkgs, lib, ... }:

{
  imports = [
    ./devtools.nix
    ./os-specific.nix
    ./programs/vscode.nix
    ./dotfiles/default.nix
  ];

  # TODO(igm): replace this with an overlay-based system
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      factorio = pkgs.factorio.override {
        username = "albireox";
        token = lib.removeSuffix "\n" (
          builtins.readFile "${config.home.homeDirectory}/private_secrets/secrets/factorio.txt"
        );
      };

      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; };

      proto3-suite = pkgs.callPackage ./programs/proto3-suite.nix { };

      rofi-systemd = pkgs.callPackage ./programs/rofi-systemd.nix { };
    };
  };

  home.packages = with pkgs; [
    exa
    fortune
    git
    htop
    gitAndTools.hub
    stack
    unzip
    wget
    whois
    xclip
    xsel

    # Editors
    emacs
    vim

    texlive.combined.scheme-basic

    go-outline
    ruby

    # google-cloud-sdk
    postgresql_11

    findutils
    coreutils-full
    clang-tools

    cmatrix
    zsh
    gnugrep
    keybase
    rustup
  ];

  programs.home-manager = {
    enable = true;
  };
}
