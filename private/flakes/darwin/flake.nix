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
      mkSystem = { isM1 ? false, modules ? [ ], computerName, hostName }:
        darwin.lib.darwinSystem {
          system = if isM1 then "aarch64-darwin" else "x86_64-darwin";
          modules = [{
            nixpkgs =
              igm.lib.mkNixpkgs { additionalOverlays = private.overlays; };
          }] ++ igm.lib.darwinModules ++ private.modules ++ modules ++ [{
            networking = {
              inherit computerName hostName;
              localHostName = hostName;
            };
            igm = {
              inherit isM1;
              mode = "personal";
            };
          }];
        };
    in
    {
      darwinConfigurations."ian-mbp" = mkSystem {
        computerName = "Ian’s Macbook Pro Intel";
        hostName = "ian-mbp-intel";
        modules = [{ services.nix-daemon.enable = true; }];
      };
      darwinConfigurations."ian-mbp-m1" = mkSystem {
        isM1 = true;
        computerName = "Ian’s Macbook Pro 2022";
        hostName = "ian-mbp-2022";
        modules = [{ services.nix-daemon.enable = true; }];
      };
    };
}
