{ config, pkgs, lib, ... }:

{
  imports = [
    ./abacus.nix
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

      jx = pkgs.callPackage ./programs/jx.nix { };

      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; };

      proto3-suite = pkgs.callPackage ./programs/proto3-suite.nix { };
    };
  };

  home.packages = with pkgs; [
    exa
    fortune
    git
    htop
    gitAndTools.hub
    sox
    stack
    unzip
    wget
    whois
    xclip
    xsel

    # Editors
    emacs
    vim

    texlive.combined.scheme-full

    go-outline
    ruby

    google-cloud-sdk
    postgresql_11

    findutils
    coreutils-full
    clang-tools

    cmatrix
    zsh
  ];

  programs.home-manager = {
    enable = true;
  };
}
