{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:/home/igm/dotfiles/nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles-private-raw = { url = "path:/home/igm/dotfiles-private"; };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, ... }:
    let
      private = import ../../dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { inherit (nixpkgs) lib; };
      };
    in
    {
      nixosConfigurations.primary = igm.lib.mkNixosSystem {
        additionalOverlays = private.overlays;
        modules = [
          ./machines/ian-nixdesktop.nix
        ] ++ private.modules ++ private.nixosModules;
        igm = {
          headless = true;
          virtualbox = false;
          vscode-server = true;
        };
      };
    };
}
