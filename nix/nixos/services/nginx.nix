{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Nginx Reverse Proxy
  services.nginx = {
    enable = true;

    package = pkgs.nginx.override { modules = with pkgs.nginxModules; [ fancyindex ]; };

    virtualHosts."nix.ian.pw" = {
      root = "/home/igm/dotfiles/nixos/www";
    };

    virtualHosts."plex.nix.ian.pw" = {
      basicAuthFile = "${pkgs.dotfiles-private.src}/other/htaccess";
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
      basicAuthFile = "${pkgs.dotfiles-private.src}/other/htaccess";
      locations."/" = {
        proxyPass = "http://ian-nixdesktop.ian.pw:9091/";
      };
    };

    virtualHosts."local.pipe-dev.com" = {
      locations."/" = {
        proxyPass = "http://localhost:3001";
      };
    };

    virtualHosts."torrents.nix.ian.pw" = {
      root = "/home/igm/torrents";
      basicAuthFile = "${pkgs.dotfiles-private.src}/other/htaccess";
      extraConfig = ''
        fancyindex on;
        fancyindex_name_length 255;
        fancyindex_exact_size off;
      '';
    };

    virtualHosts."api-aba.nix.ian.pw" = {
      locations."/" = {
        proxyPass = "http://nix.ian.pw:9663/";
      };
    };

    virtualHosts."app-aba.nix.ian.pw" = {
      locations."/" = {
        proxyPass = "http://nix.ian.pw:3000/";
      };
    };
  };
}
