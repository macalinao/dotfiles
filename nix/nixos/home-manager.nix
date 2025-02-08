{ config, ... }:

let
  homeBase = import ../home { systemConfig = config; };
in
{
  home-manager.users.igm = homeBase;
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
