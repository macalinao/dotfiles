{ config, pkgs, ... }:

let
  dotfiles-private = ../../../dotfiles-private;
  nixpkgs-config = (import ../nixpkgs/config.nix {
    overlays = [
      (self: super: {
        dotfiles-private = import ../dotfiles-private {
          inherit (super) lib;
          raw = import dotfiles-private { };
        };
      })
    ];
  });
in {
  imports = [ <home-manager/nixos> ./configuration.nix ];
  nixpkgs = nixpkgs-config;
}
