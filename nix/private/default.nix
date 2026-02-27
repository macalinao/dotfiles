{ raw, ... }:

let
  defaultConfig = {
    factorio-token = "";
  };
in
{
  # private overlays
  overlays = [
    (self: super: rec {
      factorio = super.factorio.override {
        username = "albireox";
        token = (defaultConfig // (raw { pkgs = super; })).factorio-token;
      };
    })
  ];
  modules = [ ];
  nixosModules = [
    (
      { pkgs, lib, ... }:
      let
        config = defaultConfig // (raw { inherit pkgs; });
      in
      {
        home-manager.users.igm.xdg.configFile = config.xdgFiles;
        services.openvpn.servers = import ./pia.nix {
          inherit (pkgs)
            lib
            stdenv
            openresolv
            pia-config
            ;
          dotfiles-private = config;
        };
      }
    )
  ];
}
