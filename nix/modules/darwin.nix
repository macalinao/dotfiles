{ inputs, ... }:
{
  partitionedAttrs = {
    darwinModules = "darwin";
    darwinConfigurations = "darwin";
  };

  partitions.darwin = {
    extraInputsFlake = ../darwin;
    module =
      { inputs, lib, ... }:
      let
        inherit (inputs) darwin dotfiles-private;
        darwinModule = import ../darwin/modules { inherit inputs; };
        privateModule = dotfiles-private.darwinModules.default;

        mkDarwinHost =
          {
            system,
            hostName,
            computerName ? hostName,
            localHostName ? hostName,
            private ? true,
          }:
          darwin.lib.darwinSystem {
            modules = [
              darwinModule
            ]
            ++ lib.optional private privateModule
            ++ [
              {
                nixpkgs.hostPlatform = system;
                networking = {
                  inherit computerName hostName localHostName;
                };
              }
            ];
          };
      in
      {
        flake = {
          darwinModules.default = darwinModule;

          darwinConfigurations = {
            "ian-mbp-intel" = mkDarwinHost {
              system = "x86_64-darwin";
              hostName = "ian-mbp-intel";
              computerName = "Ian's Macbook Pro Intel";
            };
            "ian-mbp-2022" = mkDarwinHost {
              system = "aarch64-darwin";
              hostName = "ian-mbp-2022";
              computerName = "Ian MBP 2022";
            };
            ci-personal = mkDarwinHost {
              system = "x86_64-darwin";
              hostName = "igm-darwin-ci";
              private = false;
            };
            ci-personal-m1 = mkDarwinHost {
              system = "aarch64-darwin";
              hostName = "igm-darwin-ci-m1";
              private = false;
            };
          };
        };
      };
  };
}
