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
        inherit (inputs) darwin dotfiles-private;
        darwinModule = import ../darwin/modules { inherit inputs; };
        privateModule = dotfiles-private.darwinModules.default;
      in
      {
        flake = {
          darwinModules.default = darwinModule;

          darwinConfigurations."ian-mbp-intel" = darwin.lib.darwinSystem {
            modules = [
              darwinModule
              privateModule

              {
                nixpkgs.hostPlatform = "x86_64-darwin";
                networking = {
                  computerName = "Ian's Macbook Pro Intel";
                  hostName = "ian-mbp-intel";
                  localHostName = "ian-mbp-intel";
                };
              }
            ];
          };
          darwinConfigurations."ian-mbp-2022" = darwin.lib.darwinSystem {
            modules = [
              darwinModule
              privateModule

              {
                nixpkgs.hostPlatform = "aarch64-darwin";
                networking = {
                  computerName = "Ian's Macbook Pro 2022";
                  hostName = "ian-mbp-2022";
                  localHostName = "ian-mbp-2022";
                };
              }
            ];
          };
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
