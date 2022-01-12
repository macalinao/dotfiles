{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:../../../nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles-private-raw = { url = "git+file:///Users/igm/dotfiles-private"; };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, ... }:
    let
      private = import ../../dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { };
      };
    in {
      nixosConfigurations = igm.nixosConfigurations // {
        primary = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [{
            nixpkgs =
              igm.lib.mkNixpkgs { additionalOverlays = private.overlays; };
          }] ++ igm.lib.linuxModules ++ private.modules ++ private.nixosModules;
        };
      };
    };
}
