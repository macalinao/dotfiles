{ config, lib, pkgs, ... }:

{
  imports = [
    # ./nginx.nix
    # ./wireguard.nix
    # ./transmission.nix
    ./virtualbox.nix
  ];

  # Tailscale config
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];
    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [
      41641 # tailscale
    ];
  };

  services.autorandr = {
    enable = true;
    defaultTarget = "main";
  };

  services.kbfs = {
    enable = true;
    mountPoint = "%t/kbfs";
    extraFlags = [ "-label %u" ];
  };

  services.keybase = { enable = true; };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.redis.servers.main = { enable = true; };

  services.xserver = {
    enable = true;
    dpi = 96;

    desktopManager = {
      xterm.enable = false;
      xfce = { enable = true; };
    };

    displayManager = {
      defaultSession = "xfce";
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "igm";
      };
    };
  };

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
}
