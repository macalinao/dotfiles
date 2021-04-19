{ config, lib, pkgs, ... }:

{
  imports = [
    ./nginx.nix
    # ./wireguard.nix
    ./pia.nix
    # ./transmission.nix
  ];

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

  services.redis = { enable = true; };

  services.xserver = {
    enable = true;
    dpi = 96;

    xkbOptions = "caps:swapescape";
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
