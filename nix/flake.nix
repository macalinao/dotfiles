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
    rnix-lsp.url = "github:nix-community/rnix-lsp/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    notifykit.url = "github:macalinao/notifykit";

    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      darwin,
      vscode-server,
      flake-utils,
      rnix-lsp,
      nix-index-database,
      notifykit,
      additional-nix-packages,
      ...
    }:
    let
      mkPrivate = import ./private;

      mkNixosSystem =
        {
          modules,
          additionalOverlays ? [ ],
          igm ? { },
        }:
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                inherit igm;
              }
            )
            (
              { ... }:
              {
                imports = [ "${vscode-server}/default.nix" ];
              }
            )
            (import ./system.nix {
              isLinux = true;
            })
            home-manager.nixosModules.home-manager
            ({
              nixpkgs = import ./nixpkgs/config.nix {
                additionalOverlays = additionalOverlays ++ [
                  additional-nix-packages.overlays.default
                  (self: super: {
                    rnix-lsp = rnix-lsp.defaultPackage.${system};
                  })
                ];
              };
            })
          ]
          ++ modules;
        };

      mkDarwinSystem =
        {
          isM1 ? false,
          additionalOverlays ? [ ],
          modules ? [ ],
          computerName,
          hostName,
        }:
        let
          system = if isM1 then "aarch64-darwin" else "x86_64-darwin";
        in
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            (
              { ... }:
              {
                igm = {
                  inherit isM1;
                  mode = "personal";
                };
                nixpkgs = import ./nixpkgs/config.nix {
                  isDarwin = true;
                  additionalOverlays = additionalOverlays ++ [
                    additional-nix-packages.overlays.default
                    (self: super: {
                      rnix-lsp = rnix-lsp.defaultPackage.${system};
                      notifykit = notifykit.packages.${system}.default;
                    })
                  ];
                };
              }
            )
            (import ./system.nix { isDarwin = true; })
            nix-index-database.darwinModules.nix-index
            home-manager.darwinModules.home-manager
          ]
          ++ modules
          ++ [
            {
              networking = {
                inherit computerName hostName;
                localHostName = hostName;
              };
              # services.nix-daemon.enable = true;
            }
          ];
        };
    in
    {
      lib = {
        inherit mkNixosSystem mkDarwinSystem mkPrivate;
      };
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
      darwinConfigurations.ci-personal-m1 = mkDarwinSystem {
        isM1 = true;
        computerName = "igm-darwin-ci-m1";
        hostName = "igm-darwin-ci-m1";
      };
    }
    // (
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
      (flake-utils.lib.eachSystem supportedSystems (
        system:
        let
          nixpkgs-config-public = (
            import ./nixpkgs/config.nix rec {
              isDarwin = nixpkgs.legacyPackages.${system}.lib.hasSuffix "-darwin" system;

              # There are lots of wrongfully broken packages on Darwin
              # https://github.com/NixOS/nixpkgs/pull/173671
              allowBroken = isDarwin;
            }
          );
          pkgs = import nixpkgs {
            inherit system;
            inherit (nixpkgs-config-public) config overlays;
          };
        in
        {
          formatter = pkgs.nixfmt;
          packages = import ./shells { inherit pkgs; } // {
            linear-cli = pkgs.linear-cli;
          };
        }
      ))
    );
}
