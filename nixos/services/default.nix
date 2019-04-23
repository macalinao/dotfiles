{ config, lib, pkgs, ... }:

{
  imports = [
    ./keybase.nix
    ./nginx.nix
    ./pia.nix
    ./postgres.nix
    ./transmission.nix
  ];


  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.redis = {
    enable = true;
  };

  services.openvpn.servers = {
    abacus = {
      config = ''config /home/igm/private_secrets/secrets/abacus.ovpn'';
    };
  };

  services.xserver = {
    enable = true;
    # displayManager.startx.enable = true;
    dpi = 96;

    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
      };
    };
  };

  # Yubikey
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  virtualisation.docker.enable = true;

  services.flexget = {
    enable = true;
    user = "transmission";
    homeDir = "/var/lib/transmission";
    config = builtins.readFile "/home/igm/private_secrets/other/flexget.yml";
  };
}
