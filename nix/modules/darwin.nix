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

        mkSystem =
          { modules }:
          darwin.lib.darwinSystem {
            specialArgs = {
              self = inputs.self;
            };
            modules = [ darwinModule ] ++ modules;
          };
      in
      {
        flake = {
          darwinModules.default = darwinModule;

          darwinConfigurations.ci-personal = mkSystem {
            modules = [
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
          darwinConfigurations.ci-personal-m1 = mkSystem {
            modules = [
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
