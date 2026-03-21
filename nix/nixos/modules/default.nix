{ inputs }:

let
  inherit (inputs)
    self
    home-manager
    additional-nix-packages
    ;
in
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../system.nix
    ../configuration.nix
    (
      { config, ... }:
      {
        home-manager.users.igm = {
          imports = [ self.homeModules.default ];
          igm.headless = config.igm.headless;
        };
        home-manager.useGlobalPkgs = true;
      }
    )
    ../services
    ../users.nix
    (
      {
        config,
        lib,
        pkgs,
        ...
      }@args:
      {
        config = lib.mkMerge [
          (lib.mkIf (!config.igm.headless) (import ../gui.nix args))
          (lib.mkIf config.igm.virtualbox (import ../services/virtualbox.nix args))
        ];
      }
    )
    ../../nix-settings.nix
    home-manager.nixosModules.home-manager
  ];

  nixpkgs = import ../../nixpkgs/config.nix {
    additionalOverlays = [
      (self: super: {
        additional-nix-packages = additional-nix-packages.packages.${self.stdenv.hostPlatform.system};
      })
    ];
  };
}
