{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    igm.url = "path:/home/igm/dotfiles";
    igm.inputs.nixpkgs.follows = "nixpkgs";

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
      nixosConfigurations.primary = igm.lib.mkNixosSystem {
        modules = [
          ./machines/ian-nixdesktop.nix
          dotfiles-private-raw.nixosModules.default
        ];
        igm = {
          hostName = "ianix";
          headless = true;
          virtualbox = false;
          vscode-server = true;
        };
      };
    };
}
