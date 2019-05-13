{ pkgs, lib, ... }:

{
  imports = [
    ./dotfiles.nix
    ./abacus.nix
    ./os-specific.nix
    ./programs/vscode.nix
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

    (callPackage ./programs/jx.nix {})
  ];

  programs.home-manager = {
    enable = true;
  };
}
