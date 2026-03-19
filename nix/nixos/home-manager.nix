{ config, ... }:

{
  home-manager.users.igm = {
    imports = [ ../home ];
    igm.headless = config.igm.headless;
  };
  home-manager.sharedModules = config.igm.homeModules;
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
