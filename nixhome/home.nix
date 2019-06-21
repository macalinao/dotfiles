{ pkgs, lib, ... }:

{
  imports = [
    ./abacus.nix
    ./os-specific.nix
    ./programs/vscode.nix
    ./dotfiles/default.nix
  ];

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
