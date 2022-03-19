{ config, pkgs, lib, ... }@args:

with lib;

let cfg = config.igm;
in
{
  options = {
    igm = {
      headless = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Do not install GUI apps, window manager, desktop environment, etc.
        '';
      };

      virtualbox = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Install VirtualBox.
        '';
      };
    };
  };
  config =
    mkMerge [
      (import ./configuration.nix args)
      (import ./services args)
      (import ./users.nix args)
      (mkIf cfg.virtualbox (import ./services/virtualbox.nix args))
    ];
}
