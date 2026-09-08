{ ... }:
{
  partitionedAttrs = {
    lib = "darwin";
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

        # Build a Mac host from the generic darwin module plus whatever
        # host-specific modules the caller passes in. Private hosts live in
        # the private `darwin-configuration` flake, which calls this and
        # supplies its own modules — this repo stays free of private inputs.
        mkDarwinHost =
          {
            system,
            hostName,
            computerName ? hostName,
            localHostName ? hostName,
            modules ? [ ],
          }:
          darwin.lib.darwinSystem {
            modules = [
              darwinModule
              {
                nixpkgs.hostPlatform = system;
                networking = {
                  inherit computerName hostName localHostName;
                };
              }
            ]
            ++ modules;
          };
      in
      {
        flake = {
          lib = { inherit mkDarwinHost; };

          darwinModules.default = darwinModule;

          # Only the CI host is defined here. Real machines are defined in
          # their own private flakes (see ~/proj/macalinao/darwin-configuration).
          #
          # nixpkgs unstable (26.11+) has dropped support for x86_64-darwin, so
          # only aarch64-darwin (Apple Silicon) hosts remain.
          darwinConfigurations = {
            ci-personal-m1 = mkDarwinHost {
              system = "aarch64-darwin";
              hostName = "igm-darwin-ci-m1";
            };
          };
        };
      };
  };
}
