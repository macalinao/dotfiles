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
        inherit (inputs) nixpkgs;
        nixosModule = import ../nixos/modules { inherit inputs; };
      in
      {
        flake = {
          nixosModules.default = nixosModule;

          nixosConfigurations.ci-home = nixpkgs.lib.nixosSystem {
            modules = [
              nixosModule
              ../nixos/machines/ci.nix
              { nixpkgs.hostPlatform = "x86_64-linux"; }
            ];
          };
          nixosConfigurations.ci-bare = nixpkgs.lib.nixosSystem {
            modules = [
              nixosModule
              ../nixos/machines/ci.nix
              {
                nixpkgs.hostPlatform = "x86_64-linux";
                igm.headless = true;
              }
            ];
          };
          nixosConfigurations.vbox-host = nixpkgs.lib.nixosSystem {
            modules = [
              nixosModule
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
