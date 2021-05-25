{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:../nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles-private-raw = {
      url = "path:../../dotfiles-private";
      flake = false;
    };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, ... }: {
    nixosConfigurations = igm.nixosConfigurations // {
      primary = let
        private = import ./dotfiles-private {
          inherit (nixpkgs) lib;
          raw = import dotfiles-private-raw { };
        };
      in igm.lib.mkSystem {
        additionalOverlays = private.overlays;
        modules = private.modules;
      };
    };
  };
}
