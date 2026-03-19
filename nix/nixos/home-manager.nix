{ config, ... }:

{
  home-manager.users.igm = {
    imports = [ ../home ];
    igm.headless = config.igm.headless;
  };
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
