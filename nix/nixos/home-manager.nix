{ config, pkgs, ... }:

{
  home-manager.users.igm = import ../home;
  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
