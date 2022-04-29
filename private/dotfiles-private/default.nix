{ raw, lib, ... }:

let
  defaultConfig = { factorio-token = ""; };
  config = defaultConfig // raw // {
    profiles = lib.mapAttrs
      (profile: profileInfo:
        {
          githubOrganization = profile;
          email = "${profile}@igm.pub";
          additionalGitConfig = "";
          additionalGitignore = "";
          additionalPrefixes = [ ];
        } // profileInfo)
      raw.profiles;
  };
in
config // {
  # private overlays
  overlays = [
    (self: super: {
      factorio = super.factorio.override {
        username = "albireox";
        token = config.factorio-token;
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
  nixosModules = [
    ({ pkgs, lib, ... }: {
      home-manager.users.igm.xdg.configFile = config.xdgFiles;
      services.openvpn.servers = import ./pia.nix {
        inherit (pkgs) lib stdenv openresolv pia-config;
        dotfiles-private = config;
      };
    })
  ];
}
