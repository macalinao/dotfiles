{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    igm.url = "path:../../../nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private-raw = { url = "path:../../../../dotfiles-private"; };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, darwin, ... }:
    let
      private = import ../../dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { };
      };
    in {
      darwinConfigurations."ian-mbp" = darwin.lib.darwinSystem {
        modules = [{
          nixpkgs =
            igm.lib.mkNixpkgs { additionalOverlays = private.overlays; };
        }] ++ (igm.lib.mkDarwinModules { mode = "personal"; })
          ++ private.modules;
      };
    };
}
