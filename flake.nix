{
  description = "Ian's dotfiles.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      imports = [
        ./nix/modules/partitions.nix
        ./nix/modules/nixos.nix
        ./nix/modules/darwin.nix
        ./nix/modules/home-manager.nix
      ];

      flake = { };
    };
}
