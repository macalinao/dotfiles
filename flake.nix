{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    dotfiles-private = {
      url = "path:../dotfiles-private";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, dotfiles-private, ... }:
    let
      nixpkgs-config = (import ./nix/nixpkgs/config.nix {
        overlays = [
          (self: super: {
            dotfiles-private = import ./nix/dotfiles-private {
              inherit (super) lib;
              raw = import dotfiles-private { };
            };
          })
        ];
      });
      myNixpkgs = import nixpkgs {
        inherit (nixpkgs-config) config overlays;
        system = "x86_64-linux";
      };
    in {
      nixosConfigurations.ian-nixdesktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs = nixpkgs-config; }
          ./nix/nixos/configuration.nix
          ./nix/nixos/machines/ian-nixdesktop.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
