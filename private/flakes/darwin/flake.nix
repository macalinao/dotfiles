{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    igm.url = "/Users/igm/dotfiles/nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private-raw = { url = "git+file:///Users/igm/dotfiles-private"; };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, darwin, ... }:
    let
      private = import ../../dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { };
      };
      mkSystem = { isM1 ? false }:
        darwin.lib.darwinSystem {
          system = if isM1 then "aarch64-darwin" else "x86_64-darwin";
          modules = [{
            nixpkgs =
              igm.lib.mkNixpkgs { additionalOverlays = private.overlays; };
          }] ++ (igm.lib.mkDarwinModules {
            inherit isM1;
            mode = "personal";
          }) ++ private.modules;
        };
    in {
      darwinConfigurations."ian-mbp" = mkSystem { };
      darwinConfigurations."ian-mbp-m1" = mkSystem { isM1 = true; };
    };
}
