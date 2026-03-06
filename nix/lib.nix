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
    notifykit
    nix-casks
    nix-search
    ;

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
                (self: super: {
                  rnix-lsp = rnix-lsp.defaultPackage.${system};
                  notifykit = notifykit.packages.${system}.default;
                  nix-casks = nix-casks.packages.${system};
                  nix-search = nix-search.packages.${system}.default;
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
        {
          igm.extraHomePackages = with additional-nix-packages.packages.${system}; [
            biome
            gogcli
            linear-cli
            lintel
            wacli
          ];
        }
      ];
    };
in
{
  inherit mkNixosSystem mkDarwinSystem mkPrivate;
}
