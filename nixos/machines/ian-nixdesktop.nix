# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d83d6906-f53f-417b-a080-e2b05f5990b8";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/ea26aee0-c2c4-4211-8bec-9551913c0a56";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/ADA4-EB17";
      fsType = "vfat";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.optimus_prime.enable = true;
  # Bus ID of the NVIDIA GPU. You can find it using lspci
  hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  # Bus ID of the Intel GPU. You can find it using lspci
  hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO(igm): separate hardware stuff from other machine-specific config
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/home/igm/torrents";
      incomplete-dir = "/home/igm/torrents/.incomplete";
      incomplete-dir-enabled = true;
      rpc-whitelist = "127.0.0.1,192.168.*.*,10.0.0.*";
      rpc-host-whitelist = "*";
      rpc-host-whitelist-enabled = true;
    };
  };

  networking.firewall.allowedTCPPorts = [
    80 # nginx
  ];

  # Nginx Reverse Proxy
  services.nginx = {
    enable = true;

    virtualHosts."nix.ian.pw" = {
      root = "/home/igm/dotfiles/nixos/www";
    };

    virtualHosts."plex.nix.ian.pw" = {
      basicAuthFile = "/home/igm/private_secrets/other/htaccess";
      # http2 can more performant for streaming: https://blog.cloudflare.com/introducing-http2/
      http2 = true;

      extraConfig = ''
        # Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
        send_timeout 100m;

        # Forward real ip and host to Plex
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $server_addr;
        proxy_set_header Referer $server_addr;
        proxy_set_header Origin $server_addr;

        # Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off.
        gzip on;
        gzip_vary on;
        gzip_min_length 1000;
        gzip_proxied any;
        gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
        gzip_disable "MSIE [1-6]\.";

        # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
        # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
        client_max_body_size 100M;

        # Plex headers
        proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
        proxy_set_header X-Plex-Device $http_x_plex_device;
        proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
        proxy_set_header X-Plex-Platform $http_x_plex_platform;
        proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
        proxy_set_header X-Plex-Product $http_x_plex_product;
        proxy_set_header X-Plex-Token $http_x_plex_token;
        proxy_set_header X-Plex-Version $http_x_plex_version;
        proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
        proxy_set_header X-Plex-Provides $http_x_plex_provides;
        proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
        proxy_set_header X-Plex-Model $http_x_plex_model;

        # Websockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Buffering off send to the client as soon as the data is received from Plex.
        proxy_redirect off;
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://ian-nixdesktop.ian.pw:32400/";
      };
    };

    virtualHosts."transmission.nix.ian.pw" = {
      basicAuthFile = "/home/igm/private_secrets/other/htaccess";
      locations."/" = {
        proxyPass = "http://ian-nixdesktop.ian.pw:9091/";
      };
    };

    virtualHosts."torrents.nix.ian.pw" = {
      root = "/home/igm/torrents";
      extraConfig = ''
        autoindex on;
      '';
    };
  };
}
