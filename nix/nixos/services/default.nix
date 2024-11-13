{
  config,
  lib,
  pkgs,
  ...
}@args:

with lib;
mkMerge [
  {
    # Tailscale config
    services.tailscale.enable = true;
    networking.firewall = {
      enable = true;
      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];
      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      # tailscale exit node
      checkReversePath = "loose";
    };

    services.autorandr = {
      enable = true;
      defaultTarget = "main";
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Yubikey
    services.pcscd.enable = true;
    services.udev.packages = [
      pkgs.yubikey-personalization
      # ledger
      pkgs.ledger-udev-rules
    ];

    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
    };

    services.lorri.enable = true;

    networking.firewall.allowedTCPPorts = [
      80 # nginx
      8123 # home-assistant
      8124 # zwave-js-server
    ];

    # Time machine NAS config
    networking.firewall.extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    services.samba = {
      enable = true;
      package = pkgs.sambaFull;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
      '';
      shares =
        let
          mkTimeCapsule = name: {
            "valid users" = "igm";
            path = "/mnt/nas/${name}";
            public = "no";
            writeable = "yes";
            "force user" = "igm";
            "fruit:aapl" = "yes";
            "fruit:time machine" = "yes";
            "vfs objects" = "catia fruit streams_xattr";
          };
        in
        builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = mkTimeCapsule name;
            })
            [
              # intel mbp
              "time-capsule-intel"
              # 2022 aarch64 mbp
              "time-capsule-22"
            ]
        );
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  }
]
