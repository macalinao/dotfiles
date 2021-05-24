_: pkgs: {
  pia-config = pkgs.stdenv.mkDerivation rec {
    name = "pia-config";

    src = pkgs.fetchurl {
      url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
      sha256 = "vDhCd4Ku3JDLZbMizW+ddK9OmIzFs8iE5DI27XpeRJE=";
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
      # Delete auth-user-pass directives, since we are injecting them later
      sed -i "s|auth-user-pass||g" "$out"/config/*.ovpn
    '';
  };
}
