# from https://github.com/illegalprime/nix/blob/1eb90ceaa9af14eba9d10d1178076e428994de0d/nixos/pia-system.nix

{ config, pkgs, lib, ... }:

with builtins;

{
  environment.systemPackages = with pkgs; [ openresolv ];

  # Configure all our servers
  # Use with `sudo systemctl start openvpn-us-east`
  services.openvpn.servers = let
    vpn_str = with lib.strings;
      file:
      removeSuffix ".ovpn" (toLower (replaceStrings [ " " ] [ "-" ] file));
  in foldl' (init: file:
    init // {
      "${vpn_str file}" = {
        config = readFile "${pkgs.pia-config}/config/${file}";
        autoStart = (vpn_str file) == "mexico";
        up =
          "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
        down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      };
    }) { } (attrNames (readDir "${pkgs.pia-config}/config"));
}
