{ config, pkgs, lib, ... }:

{
  imports = [
    ./devtools.nix
    ./os-specific.nix
    ./programs/vscode.nix
    ./dotfiles/default.nix
  ];

  # TODO(igm): replace this with an overlay-based system
  nixpkgs.config = import ./nixpkgs-config.nix {
    config = config;
    pkgs = pkgs;
    lib = lib;
  };

  home.packages = with pkgs; [
    exa
    fortune
    git
    htop
    gitAndTools.hub
    unzip
    wget
    whois
    xclip
    xsel

    # Editors
    emacs
    vim
    ruby

    findutils
    coreutils-full
    clang-tools

    cmatrix
    zsh
    gnugrep
    rustup

    keybase

    (callPackage ./programs/pypi2nix.nix { })
    # (pkgs.callPackage ./programs/migra { })
    # (pkgs.callPackage ./programs/tandem { })
  ];

  programs.home-manager = {
    enable = true;
  };
}
