{
  description = "Ian's dotfiles.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    additional-nix-packages.url = "github:macalinao/additional-nix-packages";
    dotfiles-private = {
      url = "github:macalinao/dotfiles-private-stub";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.flake-parts.follows = "flake-parts";
    };
    # Deliberately do NOT follow nixpkgs for claude-code-nix / codex-cli-nix:
    # the upstream cachix caches (claude-code.cachix.org, codex-cli.cachix.org)
    # are built against these flakes' own pinned nixpkgs. Rebinding nixpkgs
    # here forces local rebuilds on every release. The small duplication in
    # the store (second nixpkgs closure) is cheaper than rebuilding these
    # from source.
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
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
