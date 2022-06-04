{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs =
    { nixpkgs
    , home-manager
    , darwin
    , vscode-server
    , saber-overlay
    , flake-utils
    , ...
    }:
    let
      mkNixosSystem = { modules, additionalOverlays ? [ ], igm ? { } }: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ ... }: {
            inherit igm;
          })
          ({ ... }: {
            imports = [ "${vscode-server}/default.nix" ];
          })
          (import ./system.nix {
            isLinux = true;
          })
          home-manager.nixosModules.home-manager
          ({
            nixpkgs = import ./nixpkgs/config.nix {
              additionalOverlays = [ saber-overlay.overlays.default ] ++ additionalOverlays;
            };
          })
        ] ++ modules;
      };

      mkDarwinSystem = { isM1 ? false, additionalOverlays ? [ ], modules ? [ ], computerName, hostName }:
        darwin.lib.darwinSystem {
          system = if isM1 then "aarch64-darwin" else "x86_64-darwin";
          modules = [
            ({ ... }:
              {
                igm = {
                  inherit isM1;
                  mode = "personal";
                };
                nixpkgs = import ./nixpkgs/config.nix {
                  isDarwin = true;
                  additionalOverlays = [ saber-overlay.overlays.default ] ++ additionalOverlays;
                };
              })
            (import ./system.nix { isDarwin = true; })
            home-manager.darwinModules.home-manager
          ] ++ modules ++ [{
            networking = {
              inherit computerName hostName;
              localHostName = hostName;
            };
          }];
        };
    in
    {
      lib = { inherit mkNixosSystem mkDarwinSystem; };
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
          ./nixos/machines/ci.nix
        ];
      };
      darwinConfigurations.ci-personal = mkDarwinSystem {
        isM1 = false;
        computerName = "igm-darwin-ci";
        hostName = "igm-darwin-ci";
      };
    } // (
      let
        supportedSystems = [
          "aarch64-linux"
          "aarch64-darwin"
          # i have no such machines
          # "i686-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];
      in
      (flake-utils.lib.eachSystem supportedSystems
        (system:
        let
          nixpkgs-config-public = (import ./nixpkgs/config.nix rec {
            isDarwin = nixpkgs.legacyPackages.${system}.lib.hasSuffix "-darwin" system;

            # There are lots of wrongfully broken packages on Darwin
            # https://github.com/NixOS/nixpkgs/pull/173671
            allowBroken = isDarwin;
          });
          pkgs = import nixpkgs {
            inherit system;
            inherit (nixpkgs-config-public) config overlays;
          };
        in
        rec {
          packages = import ./shells { inherit pkgs; };
          defaultPackage = packages.nix;
        }))
    );
}
