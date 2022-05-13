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

      mkNixosSystem = { modules, igm ? { } }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            inherit igm;
          })
          (import ./system.nix {
            isLinux = true;
          })
          home-manager.nixosModules.home-manager
          nixpkgsModule
        ] ++ modules;
      };
    in
    {
      lib = { inherit linuxModules darwinModules mkNixpkgs; };
      nixosConfigurations.ci-home = mkNixosSystem {
        igm = {
          pure = true;
        };
        modules = [
          ./nixos/machines/ci.nix
        ];
      };
      nixosConfigurations.ci-bare = mkNixosSystem {
        igm = {
          headless = true;
          pure = true;
        };
        modules = [
          ./nixos/machines/ci.nix
        ];
      };
      nixosConfigurations.vbox-host = mkNixosSystem {
        igm = {
          headless = true;
          virtualbox = true;
          pure = true;
        };
        modules = [
          ./nixos/machines/ian-nixdesktop.nix
        ];
      };
      darwinConfigurations.ci-personal = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ({ ... }: {
            igm = {
              mode = "personal";
              isM1 = false;
            };
          })
          nixpkgsModule
          (import ./system.nix { isDarwin = true; })
          home-manager.darwinModules.home-manager
        ];
      };
    };
}
