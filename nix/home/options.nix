# Home Manager options for igm settings.
# These mirror the system-level igm options so home modules
# can access them without the systemConfig hack.
{ config, lib, ... }:

{
  options.igm = {
    claudeInstances = lib.mkOption {
      type = lib.types.int;
      default = 6;
      description = "Number of Claude Code instances (generates claude-2 through claude-N).";
    };

    headless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Do not install GUI apps, window manager, desktop environment, etc.";
    };

    dotfilesPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      defaultText = lib.literalExpression ''"''${config.home.homeDirectory}/dotfiles"'';
      description = ''
        Absolute path to the working copy of the dotfiles repo on the
        target machine. Baked into dotfiles-scripts (igm-switch, etc.)
        so they know where to run flake commands from.
      '';
    };
  };
}
