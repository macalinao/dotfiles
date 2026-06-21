{ inputs, ... }:
{
  partitionedAttrs = {
    nixosModules = "nixos";
    nixosConfigurations = "nixos";
  };

  partitions.nixos = {
    extraInputsFlake = ../nixos;
    module =
      { inputs, ... }:
      let
        inherit (inputs) nixpkgs;
        nixosModule = import ../nixos/modules { inherit inputs; };
        headlessModule = import ../nixos/modules/headless.nix { inherit inputs; };

        mkNixosHost =
          {
            system ? "x86_64-linux",
            modules ? [ ],
          }:
          nixpkgs.lib.nixosSystem {
            modules = [
              ../nixos/machines/ci.nix
              { nixpkgs.hostPlatform = system; }
            ]
            ++ modules;
          };
      in
      {
        flake = {
          nixosModules.default = nixosModule;
          nixosModules.headless = headlessModule;

          nixosConfigurations = {
            ci-headless = mkNixosHost {
              modules = [
                headlessModule
                { system.stateVersion = "24.05"; }
              ];
            };
            ci-home = mkNixosHost {
              modules = [ nixosModule ];
            };
            ci-bare = mkNixosHost {
              modules = [
                nixosModule
                { igm.headless = true; }
              ];
            };
            vbox-host = mkNixosHost {
              modules = [
                nixosModule
                {
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
  };
}
