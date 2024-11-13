{ config, pkgs, ... }:
{
  users.extraGroups.vboxusers.members = [ "igm" ];
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
}
