{
  description = "Ian's dotfiles.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
    dotfiles-private = {
      url = "file+file:///dev/null";
      flake = false;
    };
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
