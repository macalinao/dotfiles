{ config, pkgs, lib, ... }:

{
  imports = [ ./os-specific.nix ./programs/vscode.nix ./dotfiles/default.nix ];

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
    nixfmt

    (callPackage ./programs/pypi2nix.nix { })
    # (pkgs.callPackage ./programs/migra { })
  ];

  programs.home-manager = { enable = true; };

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    initExtra = ". $HOME/dotfiles/lib/zshrc";
  };
  programs.z-lua = { enable = true; };
}
