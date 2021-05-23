{ raw, lib, ... }:

raw // {
  profiles = lib.mapAttrs (profile: profileInfo:
    {
      githubOrganization = profile;
      email = "${profile}@igm.pub";
      additionalGitConfig = "";
      additionalGitignore = "";
    } // profileInfo) raw.profiles;
}
