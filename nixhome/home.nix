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

      rofi-systemd = pkgs.callPackage ./programs/rofi-systemd.nix { };

      qt5 = with pkgs; pkgs.qt5.override {
        # https://github.com/NixOS/nixpkgs/issues/63829
        # https://github.com/coreyoconnor/nixpkgs/commit/f282a93699c118d6c26e7033937f86e61a2a0890
        stdenv = if stdenv.cc.isClang
                then llvmPackages_5.stdenv
                else (if stdenv.hostPlatform.isi686 then (overrideCC stdenv buildPackages.gcc6) else stdenv);
      };

      winetricks = pkgs.winetricks.override { wine = pkgs.wine-staging; };

      league-of-legends = pkgs.callPackage ./programs/league-of-legends.nix { };
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
    gnugrep
  ];

  programs.home-manager = {
    enable = true;
  };
}
