{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, darwin, ... }:
    let
      mkNixpkgs = args: (import ./nixpkgs/config.nix) args;
      nixpkgsConfig = mkNixpkgs { };
      nixpkgsModule = { nixpkgs = nixpkgsConfig; };
      linuxModules = [
        ./nixos/configuration.nix
        ./nixos/home-manager.nix
        ./nixos/machines/ian-nixdesktop.nix
        home-manager.nixosModules.home-manager
      ];
      mkDarwinModules = { mode }: [
        (import ./darwin { inherit mode; })
        home-manager.darwinModules.home-manager
      ];
    in {
      lib = { inherit linuxModules mkDarwinModules mkNixpkgs; };
      nixosConfigurations.ci-home-common = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/users.nix
          ({
            home-manager.users.igm = import ./home/common.nix;
            home-manager.useGlobalPkgs = true;
          })
          ./nixos/machines/ci.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.ci-home-os = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/users.nix
          ({
            home-manager.users.igm = import ./home/os-specific;
            home-manager.useGlobalPkgs = true;
          })
          ./nixos/machines/ci.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.ci-home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/users.nix
          ./nixos/home-manager.nix
          ./nixos/machines/ci.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.ci-bare = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/configuration.nix
          ./nixos/machines/ci.nix
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.vbox-host = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/services/virtualbox.nix
          ./nixos/machines/ian-nixdesktop.nix
        ];
      };
      darwinConfigurations.ci = darwin.lib.darwinSystem {
        modules = [
          nixpkgsModule
          (import ./darwin { mode = "personal"; })
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
