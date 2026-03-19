# Home Manager options for igm settings.
# These mirror the system-level igm options so home modules
# can access them without the systemConfig hack.
{ lib, ... }:

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
  };
}
