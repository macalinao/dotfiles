{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    igm.url = "path:./nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { igm, flake-utils, nixpkgs, ... }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        {
          devShells = igm.devShells.${system};
          devShell = igm.devShell.${system};
        })) // {
      inherit (igm) nixosConfigurations;
    };
}
