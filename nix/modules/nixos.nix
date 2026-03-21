{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitionedAttrs = {
    nixosModules = "nixos";
    nixosConfigurations = "nixos";
  };

  partitions.nixos = {
    extraInputsFlake = ../nixos;
    module =
      { inputs, ... }:
      let
        inherit (inputs)
          nixpkgs
          home-manager
          additional-nix-packages
          ;

        nixosModule = {
          imports = [
            ../system.nix
            ../nixos/configuration.nix
            ../nixos/home-manager.nix
            ../nixos/services
            ../nixos/users.nix
            (
              {
                config,
                lib,
                pkgs,
                ...
              }@args:
              {
                config = lib.mkMerge [
                  (lib.mkIf (!config.igm.headless) (import ../nixos/gui.nix args))
                  (lib.mkIf config.igm.virtualbox (import ../nixos/services/virtualbox.nix args))
                ];
              }
            )
            ../nix-settings.nix
            home-manager.nixosModules.home-manager
          ];

          nixpkgs = import ../nixpkgs/config.nix {
            additionalOverlays = [
              (self: super: {
                additional-nix-packages = additional-nix-packages.packages.${self.stdenv.hostPlatform.system};
              })
            ];
          };
        };

        mkSystem =
          { modules }:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              self = inputs.self;
            };
            modules = [ nixosModule ] ++ modules;
          };
      in
      {
        flake = {
          nixosModules.default = nixosModule;

          nixosConfigurations.ci-home = mkSystem {
            modules = [
              ../nixos/machines/ci.nix
              { nixpkgs.hostPlatform = "x86_64-linux"; }
            ];
          };
          nixosConfigurations.ci-bare = mkSystem {
            modules = [
              ../nixos/machines/ci.nix
              {
                nixpkgs.hostPlatform = "x86_64-linux";
                igm.headless = true;
              }
            ];
          };
          nixosConfigurations.vbox-host = mkSystem {
            modules = [
              ../nixos/machines/ci.nix
              {
                nixpkgs.hostPlatform = "x86_64-linux";
                igm = {
                  headless = true;
                  virtualbox = true;
                };
              }
            ];
          };
        };
      };
  };
}
