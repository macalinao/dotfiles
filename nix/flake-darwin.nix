{ inputs, ... }:

let
  inherit (import ./lib.nix { inherit inputs; }) mkDarwinSystem;
in
{
  flake = {
    darwinConfigurations.ci-personal = mkDarwinSystem {
      isM1 = false;
      computerName = "igm-darwin-ci";
      hostName = "igm-darwin-ci";
    };
    darwinConfigurations.ci-personal-m1 = mkDarwinSystem {
      isM1 = true;
      computerName = "igm-darwin-ci-m1";
      hostName = "igm-darwin-ci-m1";
    };
  };
}
