{ isLinux ? false, isDarwin ? false }:
{ config, pkgs, lib, ... }@args:

with lib;

let
  cfg = config.igm;
in
{
  options = {
    igm = {
      mode = mkOption {
        type = types.str;
        default = "personal";
        description = ''
          Mode.
        '';
      };

      isM1 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true, this is to be compiled for an M1.
        '';
      };

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
    (if isLinux then
      (mkMerge [
        (import ./nixos/configuration.nix args)
        (import ./nixos/home-manager.nix args)
        (import ./nixos/services args)
        (import ./nixos/services/home-assistant.nix args)
        (mkIf cfg.virtualbox (import ./nixos/services/virtualbox.nix args))
        (import ./nixos/users.nix args)
      ]) else { }) //
    (if isDarwin then
      (mkMerge [
        (import ./darwin args)
      ]) else { });
}