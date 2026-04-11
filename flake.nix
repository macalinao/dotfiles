{
  description = "Ian's dotfiles.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
    dotfiles-private.url = "github:macalinao/dotfiles-private-stub";
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
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
        ./nix/modules/overlays.nix
        ./nix/modules/nixos.nix
        ./nix/modules/darwin.nix
        ./nix/modules/home-manager.nix
      ];

      flake = { };
    };
}
