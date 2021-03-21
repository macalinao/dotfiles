{ config, pkgs, lib, ... }:

lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux {
    xsession.enable = true;
    xsession.profileExtra = "$HOME/dotfiles/bin/desktop_monitors.sh";

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ../../dotfiles/xmonad/xmonad.hs;
    };

    home.packages = with pkgs; [
      # Browsers
      brave
      chromium
      firefox
      google-chrome

      # Media
      spotify
      vlc

      # Comms
      discord
      signal-desktop
      tdesktop
      slack
      zoom-us

      # Developer
      insomnia
      postman

      # Etc
      rofi-systemd

      # Video
      libreoffice

      # games
      # factorio
      minecraft
      # openttd

      keybase-gui
      ledger-live-desktop
      solaar

      xclip
      xsel
      playerctl

      # scripts
      configure-monitors
    ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 24 * 60 * 60;
      maxCacheTtl = 24 * 60 * 60;
      enableSshSupport = true;
    };

    services.xscreensaver.enable = true;

    programs.kitty = { enable = true; };

    programs.rofi = {
      enable = true;
      package =
        pkgs.rofi.override { plugins = with pkgs; [ rofi-emoji rofi-calc ]; };
      theme = "Arc-Dark";
    };

    services.polybar = {
      enable = true;
      script = "polybar top &";
      config = {
        "bar/top" = {
          font-0 = "Inter:pixelsize=12;4";
          font-1 = "Noto Emoji:scale=10;4";
          monitor = "DP-0";
          width = "100%";
          height = "3%";
          radius = 0;
          modules-left = "time-cet";
          modules-center = "date";
          modules-right = "alsa";
        };

        "module/alsa" = {
          type = "internal/alsa";
          format-volume = "<ramp-volume> <label-volume>";
          label-muted = "🔇 muted";
          ramp-volume-0 = "🔈";
          ramp-volume-1 = "🔉";
          ramp-volume-2 = "🔊";
        };

        "module/date" = {
          type = "internal/date";
          internal = 1;
          date = "%F";
          time = "%T %Z";
          label = "%date% %time%";
        };

        "module/time-cet" = {
          type = "custom/script";
          exec = ''TZ=CET ${pkgs.coreutils}/bin/date +"%F %T %Z"'';
          interval = 1;
        };
      };
    };
  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      reattach-to-user-namespace
      pinentry_mac
      gnupg
    ];

    home.file.".gnupg/gpg-agent.conf" = {
      text =
        "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
    };
  })
]
