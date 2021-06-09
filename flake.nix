{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    igm.url = "path:./nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { igm, flake-utils, nixpkgs, pre-commit-hooks, ... }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        nixpkgs-config-public = (import ./nix/nixpkgs/config.nix { });
        pkgs = import nixpkgs {
          inherit system;
          inherit (nixpkgs-config-public) config overlays;
        };
      in {
        devShell = import ./shell.nix {
          inherit pkgs;
          nix-pre-commit-hooks = pre-commit-hooks.lib.${system};
        };
      })) // {
        inherit (igm) nixosConfigurations;
      };
}
