{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server/master";
      flake = false;
    };
  };

  outputs = { nixpkgs, home-manager, darwin, vscode-server, ... }:
    let
      mkNixpkgs = args: (import ./nixpkgs/config.nix) args;
      nixpkgsConfig = mkNixpkgs { };
      nixpkgsModule = { nixpkgs = nixpkgsConfig; };

      linuxModules = [
        ({ ... }: {
          igm = {
            headless = true;
            virtualbox = false;
          };
        })
        (import ./system.nix { isLinux = true; })
        ./nixos/machines/ian-nixdesktop.nix
        home-manager.nixosModules.home-manager
        ({ ... }: {
          imports = [ "${vscode-server}/default.nix" ];
          services.vscode-server.enable = true;
        })
      ];
      darwinModules = [
        (import ./system.nix { isDarwin = true; })
        home-manager.darwinModules.home-manager
      ];
    in
    {
      lib = { inherit linuxModules darwinModules mkNixpkgs; };
      nixosConfigurations.ci-home-common = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgsModule
          ./nixos/users.nix
          ({
            home-manager.users.igm = ./home/common.nix;
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
          ./nixos/module.nix
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
      darwinConfigurations.ci-personal = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          nixpkgsModule
          (import ./darwin { mode = "personal"; })
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
