_: pkgs: rec {
  # separate this out so we can cache the derivation
  pia-config-base = pkgs.stdenv.mkDerivation rec {
    name = "pia-config-base";

    src = pkgs.fetchurl {
      url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
      sha256 = "14a4brxfsdijwj2cicy5ijc4xbvlkmpws8mkcp5r1p5fh9vl4f5w";
    };

    unpackPhase = ''
      ${pkgs.unzip}/bin/unzip $src
    '';

    installPhase = ''
      mkdir -p "$out/uuids"
      ls *.ovpn | while read FILE; do
        ${pkgs.libuuid}/bin/uuidgen --md5 -n @url -N "$FILE" > "$out/uuids/$FILE"
      done
      mkdir -p "$out/config"
      mv *.ovpn "$out/config"
      mkdir -p "$out/certs"
      mv *.crt *.pem "$out/certs"
    '';

    fixupPhase = ''
      sed -i "s|crl.rsa.2048.pem|$out/certs/\0|g" "$out"/config/*.ovpn
      sed -i "s|ca.rsa.2048.crt|$out/certs/\0|g" "$out"/config/*.ovpn
    '';
  };

  pia-config = pkgs.stdenv.mkDerivation rec {
    name = "pia-config";

    installPhase = ''
      mkdir -p "$out/config"
      cp -R ${pia-config-base}/config/*.ovpn $out/config
    '';

    # no src
    unpackPhase = "true";

    fixupPhase = ''
      sed -i "s|auth-user-pass|auth-user-pass ${pkgs.dotfiles-private.src}/other/pia.conf|g" "$out"/config/*.ovpn
    '';
  };

  # Configure all our servers
  # Use with `sudo systemctl start openvpn-us-east`
  pia-openvpn-servers = with builtins;
    let
      vpn_str = with pkgs.lib.strings;
        file:
        removeSuffix ".ovpn" (toLower (replaceStrings [ " " ] [ "-" ] file));
    in foldl' (init: file:
      init // {
        "${vpn_str file}" = {
          config = readFile "${pia-config}/config/${file}";
          autoStart = (vpn_str file) == "mexico";
          up =
            "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
          down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
        };
      }) { } (attrNames (readDir "${pia-config}/config"));
}
