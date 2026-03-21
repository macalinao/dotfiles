{ config, self, ... }:

{
  home-manager.users.igm = {
    imports = [ self.homeModules.default ];
    igm.headless = config.igm.headless;
  };
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
