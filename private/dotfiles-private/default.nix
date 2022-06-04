{ raw, lib, ... }:

let
  defaultConfig = { factorio-token = ""; };
  config = defaultConfig // raw // {
    profiles = lib.mapAttrs
      (profile:
        { email ? "${profile}-github@igm.pub"
        , github ? { }
        , additionalGitConfig ? ""
        , additionalGitignore ? ""
        , additionalPrefixes ? [ ]
        , ...
        }@profileInfo:
        profileInfo // {
          inherit name email github additionalGitConfig additionalGitignore additionalPrefixes;
        } // {
          github =
            ({
              username = "macalinao";
              organization = profile;
            } // github);
        })
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
