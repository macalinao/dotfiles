{ isLinux ? false, isDarwin ? false }:
{ config, pkgs, lib, ... }@args:

with lib;

let
  cfg = config.igm;
in
{
  options.igm = {
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

    pure = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Only install pure packages.
      '';
    };

    vscode-server = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Install VSCode Server.
      '';
    };

    hostName = mkOption {
      type = types.str;
      default = "igm-machine";
      description = ''
        Host name of the machine.
      '';
    };

    homeModules = mkOption {
      type = types.listOf types.lambda;
      default = [ ];
      description = ''
        Additional modules to merge into the home module.
      '';
    };
  };

  config =
    (if isLinux then
      (mkMerge [
        (import ./nixos/configuration.nix args)
        (import ./nixos/home-manager.nix args)
        (import ./nixos/services args)
        # (import ./nixos/services/home-assistant.nix args)
        (mkIf (!cfg.headless) (import ./nixos/gui.nix args))
        (mkIf cfg.virtualbox (import ./nixos/services/virtualbox.nix args))
        (import ./nixos/users.nix args)
        (mkIf cfg.vscode-server {
          services.vscode-server.enable = true;
        })
      ]) else { }) //
    (if isDarwin then
      (mkMerge [
        (import ./darwin args)
      ]) else { });
}
