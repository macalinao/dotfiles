{
  description = "Ian's dotfiles.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    igm.url = "path:/Users/igm/dotfiles/nix";
    igm.inputs.nixpkgs.follows = "nixpkgs";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles-private-raw = { url = "path:/Users/igm/dotfiles-private"; };
  };

  outputs = { igm, dotfiles-private-raw, nixpkgs, darwin, ... }:
    let
      private = import ../../dotfiles-private {
        inherit (nixpkgs) lib;
        raw = import dotfiles-private-raw { };
      };
      mkSystem = igm.lib.mkDarwinSystem;
    in
    {
      darwinConfigurations."ian-mbp" = mkSystem {
        computerName = "Ian’s Macbook Pro Intel";
        hostName = "ian-mbp-intel";
        additionalOverlays = private.overlays;
        modules = private.modules ++ [{ services.nix-daemon.enable = true; }];
      };
      darwinConfigurations."ian-mbp-m1" = mkSystem {
        isM1 = true;
        computerName = "Ian’s Macbook Pro 2022";
        hostName = "ian-mbp-2022";
        additionalOverlays = private.overlays;
        modules = private.modules ++ [{ services.nix-daemon.enable = true; }];
      };
    };
}
