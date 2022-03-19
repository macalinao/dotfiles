{ config, pkgs, ... }@args:

{
  home-manager.users.igm = import ../home { systemConfig = config; };
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
