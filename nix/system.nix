{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  options.igm = {
    mode = mkOption {
      type = types.str;
      default = "personal";
      description = ''
        Mode.
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
}
