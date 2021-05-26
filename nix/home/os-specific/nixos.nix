{ config, pkgs, lib, ... }:

{
  xsession.enable = true;
  xsession.profileExtra = "$HOME/dotfiles/bin/desktop_monitors.sh";

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../xmonad/xmonad.hs;
  };

  xdg.configFile = pkgs.dotfiles-private.xdgFiles;

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
    gnome3.gnome-keyring
    gnome3.seahorse

    # scripts
    configure-monitors
    ngrok-1
    vagrant
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
        font-0 = "Inter:pixelsize=12;6";
        font-1 = "Noto Emoji:scale=10;6";
        monitor = "DP-0";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-left = "time-cet";
        modules-center = "time-computer";
        modules-right = "alsa";
        padding = 2;
      };

      "module/alsa" = {
        type = "internal/alsa";
        format-volume = "<ramp-volume> <label-volume>";
        label-muted = "🔇 muted";
        ramp-volume-0 = "🔈";
        ramp-volume-1 = "🔉";
        ramp-volume-2 = "🔊";
      };

      "module/time-computer" = {
        type = "custom/script";
        exec = "${pkgs.coreutils}/bin/date";
        interval = 1;
      };

      "module/time-cet" = {
        type = "custom/script";
        exec = "TZ=CET ${pkgs.coreutils}/bin/date";
        interval = 1;
      };
    };
  };
}
