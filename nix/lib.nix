{ inputs }:

let
  inherit (inputs)
    nixpkgs
    home-manager
    darwin
    vscode-server
    rnix-lsp
    nix-index-database
    additional-nix-packages
    nix-casks
    ;

  mkNixosSystem =
    {
      modules,
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
        ./nix-settings.nix
        home-manager.nixosModules.home-manager
        ({
          nixpkgs = import ./nixpkgs/config.nix {
            additionalOverlays = [
              (self: super: {
                rnix-lsp = rnix-lsp.defaultPackage.${system};
              })
            ];
          };
        })
        {
          igm.extraHomePackages = with additional-nix-packages.packages.${system}; [
            biome
            gogcli
            linear-cli
            lintel
            wacli
          ];
        }
      ]
      ++ modules;
    };

  mkDarwinSystem =
    {
      isM1 ? false,
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
              additionalOverlays = [
                (self: super: {
                  rnix-lsp = rnix-lsp.defaultPackage.${system};
                  nix-casks = nix-casks.packages.${system};
                })
              ];
            };
          }
        )
        (import ./system.nix { isDarwin = true; })
        ./nix-settings.nix
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
        {
          igm.extraHomePackages = with additional-nix-packages.packages.${system}; [
            biome
            gogcli
            linear-cli
            lintel
            notifykit
            wacli
          ];
        }
      ];
    };
in
{
  inherit mkNixosSystem mkDarwinSystem;
}
