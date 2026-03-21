{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm = {
      url = "path:/home/igm/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private-raw = {
      url = "path:/home/igm/dotfiles-private";
    };
  };

  outputs =
    {
      igm,
      dotfiles-private-raw,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations.primary = nixpkgs.lib.nixosSystem {
        modules = [
          igm.nixosModules.default
          dotfiles-private-raw.nixosModules.default
          ./machines/ian-nixdesktop.nix
          {
            nixpkgs.hostPlatform = "x86_64-linux";
            networking.hostName = "ianix";
            igm = {
              headless = true;
              virtualbox = false;
            };
          }
        ];
      };
    };
}
