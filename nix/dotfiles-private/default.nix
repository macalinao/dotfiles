{ lib, ... }:

let
  raw = (if (builtins.pathExists ../../../dotfiles-private) then
    (import ../../../dotfiles-private { inherit lib; })
  else {
    profiles = { };
    factorio-token = "";
  });
in raw // {
  profiles = lib.mapAttrs (profile: profileInfo:
    {
      githubOrganization = profile;
      email = "${profile}@igm.pub";
    } // profileInfo) raw.profiles;
}
