{ raw, lib, ... }:

let
  defaultConfig = { factorio-token = ""; };
  config = defaultConfig // raw // {
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
    (self: super: {
      factorio = super.factorio.override {
        username = "albireox";
        token = config.factorio-token;
      };
      pia-openvpn-servers = import ./pia.nix {
        inherit (super) lib stdenv openresolv pia-config;
        dotfiles-private = config;
      };
    })
  ];
  modules = [
    ({ pkgs, lib, ... }: {
      home-manager.users.igm = import ./home.nix {
        inherit lib pkgs;
        dotfiles-private = config;
      };
    })
  ];
}
