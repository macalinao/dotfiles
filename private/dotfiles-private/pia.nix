{ dotfiles-private, lib, stdenv, pia-config, openresolv }:
let
  vpn_str = with lib.strings;
    file:
    removeSuffix ".ovpn" (toLower (replaceStrings [ " " ] [ "-" ] file));
  # Configure all our servers
  # Use with `sudo systemctl start openvpn-us-east`
in
with builtins;
foldl'
  (init: file:
    init // {
      "${vpn_str file}" = {
        config = ''
          ${readFile "${pia-config}/config/${file}"}
          auth-user-pass ${dotfiles-private.src}/other/pia.conf
        '';
        autoStart = (vpn_str file) == "mexico";
        up =
          "echo nameserver $nameserver | ${openresolv}/sbin/resolvconf -m 0 -a $dev";
        down = "${openresolv}/sbin/resolvconf -d $dev";
      };
    })
{ }
  (attrNames (readDir "${pia-config}/config"))
