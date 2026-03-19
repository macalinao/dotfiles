{
  description = "Ian's dotfiles.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
    nix-casks = {
      url = "github:atahanyorganci/nix-casks/archive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
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
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
        ./nix/per-system.nix
        ./nix/flake-nixos.nix
        ./nix/flake-darwin.nix
      ];

      flake = {
        lib = {
          inherit (import ./nix/lib.nix { inherit inputs; })
            mkNixosSystem
            mkDarwinSystem
            ;
        };

        homeManagerModules = {
          headless = import ./nix/home/headless.nix;
        };
      };
    };
}
