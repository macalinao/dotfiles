# from https://github.com/illegalprime/nix/blob/1eb90ceaa9af14eba9d10d1178076e428994de0d/nixos/pia-system.nix

{ config, pkgs, ... }:

with builtins;

let pia-config = with pkgs; stdenv.mkDerivation rec {
  name = "pia-config";

  buildInputs = [
    unzip
    libuuid
  ];

  src = fetchurl {
    url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
    sha256 = "2db040c198d8657c92e5c0b106546a337c7857f2b1f021e5c5affe4fe775814e";
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
    sed -i "s|auth-user-pass|auth-user-pass /home/igm/private_secrets/other/pia.conf|g" "$out"/config/*.ovpn
  '';
};
in
{
  environment.systemPackages = with pkgs; [
    openresolv
  ];

  # Configure all our servers
  # Use with `sudo systemctl start openvpn-us-east`
  services.openvpn.servers = let
    vpn_str = with (import <nixpkgs> {}).lib.strings;
              file: removeSuffix ".ovpn" (toLower (replaceStrings [" "] ["-"] file));
  in
  foldl' (init: file: init // {
    "${vpn_str file}" = {
      config = readFile "${pia-config}/config/${file}";
      autoStart = (vpn_str file) == "us-silicon-valley";
      up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
      down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
    };
  }) {} (
    attrNames (readDir "${pia-config}/config")
  );
}
