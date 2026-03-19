{ inputs }:

let
  inherit (inputs)
    nixpkgs
    home-manager
    darwin
    nix-index-database
    additional-nix-packages
    nix-casks
    ;

  additionalOverlay = system: self: super: {
    additional-nix-packages = additional-nix-packages.packages.${system};
  };

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
        (import ./system.nix {
          isLinux = true;
        })
        ./nix-settings.nix
        home-manager.nixosModules.home-manager
        ({
          nixpkgs = import ./nixpkgs/config.nix {
            additionalOverlays = [ (additionalOverlay system) ];
          };
        })
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
              mode = "personal";
            };
            nixpkgs = import ./nixpkgs/config.nix {
              isDarwin = true;
              additionalOverlays = [
                (additionalOverlay system)
                (self: super: {
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
      ];
    };
in
{
  inherit mkNixosSystem mkDarwinSystem;
}
