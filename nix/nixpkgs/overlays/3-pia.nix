_: pkgs: {
  pia-config = pkgs.stdenv.mkDerivation rec {
    name = "pia-config";

    buildInputs = with pkgs; [ unzip libuuid ];

    src = pkgs.fetchurl {
      url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
      sha256 = "sha256:14a4brxfsdijwj2cicy5ijc4xbvlkmpws8mkcp5r1p5fh9vl4f5w";
    };

    unpackPhase = ''
      unzip $src
    '';

    installPhase = ''
      mkdir -p "$out/uuids"
      ls *.ovpn | while read FILE; do
        uuidgen --md5 -n @url -N "$FILE" > "$out/uuids/$FILE"
      done
      mkdir -p "$out/config"
      mv *.ovpn "$out/config"
      mkdir -p "$out/certs"
      mv *.crt *.pem "$out/certs"
    '';

    fixupPhase = ''
      sed -i "s|crl.rsa.2048.pem|$out/certs/\0|g" "$out"/config/*.ovpn
      sed -i "s|ca.rsa.2048.crt|$out/certs/\0|g" "$out"/config/*.ovpn
      sed -i "s|auth-user-pass|auth-user-pass ${pkgs.dotfiles-private.src}/other/pia.conf|g" "$out"/config/*.ovpn
    '';
  };
}
