{ config, lib, pkgs, ... }:

{
  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/home/igm/torrents";
      incomplete-dir = "/home/igm/torrents/.incomplete";
      incomplete-dir-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.*.*,10.0.0.*";
      rpc-host-whitelist = "*";
      rpc-host-whitelist-enabled = true;
      ratio-limit = 0;
      ratio-limit-enabled = true;
    };
  };

  systemd.services.transmission = {...}: {
    options = {
      serviceConfig = lib.mkOption {
        apply = old: old // {
          ExecStartPre = pkgs.writeScript "transmission-pre-start-two" ''
            #!${pkgs.runtimeShell}
            ${old.ExecStartPre}
            chmod 777 /home/igm/torrents
          '';
        };
      };
    };
  };

}
