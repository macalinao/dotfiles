{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:/home/igm/dotfiles/nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles-private-raw = {
      url = "path:/home/igm/dotfiles-private";
    };
  };

  outputs =
    {
      igm,
      dotfiles-private-raw,
      nixpkgs,
      ...
    }:
    let
      private = igm.lib.mkPrivate {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw;
      };
      hmSecrets = {
        home-manager.users.igm = {
          imports = [
            dotfiles-private-raw.homeManagerModules.age
            dotfiles-private-raw.homeManagerModules.default
          ];
        };
      };
    in
    {
      nixosConfigurations.primary = igm.lib.mkNixosSystem {
        additionalOverlays = private.overlays;
        modules = [
          ./machines/ian-nixdesktop.nix
          hmSecrets
        ]
        ++ private.modules
        ++ private.nixosModules;
        igm = {
          hostName = "ianix";
          headless = true;
          virtualbox = false;
          vscode-server = true;
        };
      };
    };
}
