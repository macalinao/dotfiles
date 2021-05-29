{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:../nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private-raw = {
      url = "path:../../dotfiles-private";
      flake = false;
    };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, darwin, ... }:
    let
      private = import ./dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { };
      };
    in {
      nixosConfigurations = igm.nixosConfigurations // {
        primary = igm.lib.mkSystem {
          additionalOverlays = private.overlays;
          modules = private.modules;
        };
      };
      darwinConfigurations."ian-mbp" = igm.lib.mkSystem {
        system = "x86_64-darwin";
        additionalOverlays = private.overlays;
        builder = darwin.lib.darwinSystem;
        modules = private.modules;
      };
    };
}
