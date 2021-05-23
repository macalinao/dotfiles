{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dotfiles-private = {
      url = "path:../dotfiles-private";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, dotfiles-private, flake-utils
    , pre-commit-hooks, ... }:
    let
      private = import ./nix/dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private { };
      };
      nixpkgs-config =
        (import ./nix/nixpkgs/config.nix { overlays = private.overlays; });
      systemConfigs = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            inherit (nixpkgs-config) config overlays;
          };
        in {
          devShell = import ./shell.nix {
            inherit pkgs;
            nix-pre-commit-hooks = pre-commit-hooks.lib.${system};
          };
        });
    in systemConfigs // {
      nixosConfigurations.primary = nixpkgs.lib.nixosSystem {
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
