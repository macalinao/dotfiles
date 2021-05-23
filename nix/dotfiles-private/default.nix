{ raw, lib, ... }:

let
  config = raw // {
    profiles = lib.mapAttrs (profile: profileInfo:
      {
        githubOrganization = profile;
        email = "${profile}@igm.pub";
        additionalGitConfig = "";
        additionalGitignore = "";
      } // profileInfo) raw.profiles;
  };
in config // {
  # private overlays
  overlays = [
    (self: super: { dotfiles-private = config; })
    (self: super: {
      factorio = super.factorio.override {
        username = "albireox";
        token = config.factorio-token;
      };
    })
    (import ./overlays/3-pia.nix)
  ];
}
