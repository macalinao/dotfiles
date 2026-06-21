{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
    ./dev-partition.nix
  ];

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };
}
