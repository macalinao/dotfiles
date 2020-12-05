{ config, pkgs, lib, ... }:

{
  imports = [
    ./os-specific.nix
    ./programs/vscode.nix
    ./dotfiles/default.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;

  home.packages = with pkgs; [
    exa
    git
    gitAndTools.hub
    htop
    jq
    silver-searcher
    tmux
    unzip
    wget
    whois
    xclip
    xsel

    # Editors
    vim

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

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;
}
