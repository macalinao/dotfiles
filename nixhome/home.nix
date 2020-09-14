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

      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-14_x; };

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
    keybase-gui

    (pkgs.callPackage ./programs/pypi2nix.nix { })
    # (pkgs.callPackage ./programs/migra { })
  ];

  programs.home-manager = {
    enable = true;
  };
}
