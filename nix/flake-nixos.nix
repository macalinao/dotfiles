{ inputs, ... }:

let
  inherit (import ./lib.nix { inherit inputs; }) mkNixosSystem;
in
{
  flake = {
    nixosConfigurations.ci-home = mkNixosSystem {
      igm = {
        pure = true;
      };
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
    nixosConfigurations.ci-bare = mkNixosSystem {
      igm = {
        headless = true;
        pure = true;
      };
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
    nixosConfigurations.vbox-host = mkNixosSystem {
      igm = {
        headless = true;
        virtualbox = true;
        pure = true;
      };
      modules = [
        ./nixos/machines/ci.nix
      ];
    };
  };
}
