{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, darwin, ... }:
    let
      mkSystem = { additionalOverlays ? [ ], modules ? [ ]
        , builder ? nixpkgs.lib.nixosSystem, system, mode ? "personal" }:
        let
          stdenv = nixpkgs.legacyPackages.${system}.stdenv;
          lib = nixpkgs.legacyPackages.${system}.lib;
        in builder ({
          modules = [{
            nixpkgs =
              import ./nixpkgs/config.nix { inherit additionalOverlays; };
          }] ++ (lib.optionals stdenv.isLinux [
            (import ./nixos/configuration.nix { inherit mode; })
            ./nixos/machines/ian-nixdesktop.nix
            home-manager.nixosModules.home-manager
          ]) ++ (lib.optionals stdenv.isDarwin [
            (import ./darwin { inherit mode; })
            home-manager.darwinModules.home-manager
          ]) ++ modules;
        } // (if stdenv.isLinux then { inherit system; } else { }));
    in {
      lib = { inherit mkSystem; };
      nixosConfigurations.ci = mkSystem { system = "x86_64-linux"; };
      nixosConfigurations.ci-bare = mkSystem {
        system = "x86_64-linux";
        mode = "bare";
      };
      darwinConfigurations.ci = mkSystem {
        system = "x86_64-darwin";
        builder = darwin.lib.darwinSystem;
      };
    };
}
