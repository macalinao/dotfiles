{ inputs, ... }:

let
  inherit (import ./lib.nix { inherit inputs; }) mkNixosSystem;
in
{
  flake = {
    nixosConfigurations.ci-home = mkNixosSystem {
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
    nixosConfigurations.ci-bare = mkNixosSystem {
      igm = {
        headless = true;
      };
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
    nixosConfigurations.vbox-host = mkNixosSystem {
      igm = {
        headless = true;
        virtualbox = true;
      };
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
  };
}
