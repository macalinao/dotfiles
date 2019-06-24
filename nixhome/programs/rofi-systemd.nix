{ fetchFromGitHub }:

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "rofi-systemd";
  src = fetchFromGitHub {
    owner  = "IvanMalison";
    repo   = "rofi-systemd";
    rev    = "6e6169b56cb0cbae8a9b9f5fcf1e18d594dd2394";
    sha256 = "1dbygq3qaj1f73hh3njdnmibq7vi6zbyzdc6c0j989c0r1ksv0zi";
  };

  installPhase = ''
    # Make the output directory
    mkdir -p $out/bin

    # Copy the script there and make it executable
    cp rofi-systemd $out/bin/
    chmod +x $out/bin/rofi-systemd
  '';
}
