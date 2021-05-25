{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkSystem = { additionalOverlays ? [ ], modules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
              nixpkgs =
                import ./nixpkgs/config.nix { inherit additionalOverlays; };
            }
            ./nixos/configuration.nix
            ./nixos/machines/ian-nixdesktop.nix
            home-manager.nixosModules.home-manager
          ] ++ modules;
        };
    in {
      lib = { inherit mkSystem; };
      nixosConfigurations = { ci = mkSystem { }; };
    };
}
