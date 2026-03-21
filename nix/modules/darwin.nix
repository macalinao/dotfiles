{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitionedAttrs = {
    darwinModules = "darwin";
    darwinConfigurations = "darwin";
  };

  partitions.darwin = {
    extraInputsFlake = ../darwin;
    module =
      { inputs, ... }:
      let
        inherit (inputs) darwin;
        darwinModule = import ../darwin/modules { inherit inputs; };
      in
      {
        flake = {
          darwinModules.default = darwinModule;

          darwinConfigurations.ci-personal = darwin.lib.darwinSystem {
            modules = [
              darwinModule
              {
                nixpkgs.hostPlatform = "x86_64-darwin";
                networking = {
                  computerName = "igm-darwin-ci";
                  hostName = "igm-darwin-ci";
                  localHostName = "igm-darwin-ci";
                };
              }
            ];
          };
          darwinConfigurations.ci-personal-m1 = darwin.lib.darwinSystem {
            modules = [
              darwinModule
              {
                nixpkgs.hostPlatform = "aarch64-darwin";
                networking = {
                  computerName = "igm-darwin-ci-m1";
                  hostName = "igm-darwin-ci-m1";
                  localHostName = "igm-darwin-ci-m1";
                };
              }
            ];
          };
        };
      };
  };
}
