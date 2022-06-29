{ config, pkgs, lib, ... }:

let
  configure-monitors = pkgs.writeShellScriptBin "configure-monitors" ''
    configure_monitors() {
      ${pkgs.xorg.xrandr}/bin/xrandr \
        --output DVI-D-0 --off \
        --output HDMI-0 --mode 3840x2160 --pos 3840x0 --rotate normal \
        --output HDMI-1 --mode 2560x1440 --pos 2161x2160 --rotate normal --rate 143.91 \
        --output DP-0 --mode 2560x1440 --pos 4721x2160 --rotate normal --rate 165.08 \
        --output DP-1 --off \
        --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal \
        --output DP-3 --off \
        --output DP-2-3 --mode 3840x2160 --pos 7281x2160 --rotate normal \
        --output HDMI-2-2 --off \
        --output HDMI-2-3 --off \
        --output DP-2-4 --off \
        --output HDMI-2-4 --off
    }

    configure_monitors
  '';
in
{
  xsession.enable = true;
  xsession.profileExtra = "$HOME/dotfiles/bin/desktop_monitors.sh";

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ../../xmonad/xmonad.hs;
  };

  home.packages = with pkgs; [
    # Browsers
    brave
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

    configure-monitors

    # for xmonad
    haskell-language-server
    cabal-install
    stack
    ghc
  ];

  services.xscreensaver.enable = true;

  programs.rofi = {
    enable = true;
    package =
      pkgs.rofi.override { plugins = with pkgs; [ rofi-emoji rofi-calc ]; };
    theme = "Arc-Dark";
  };

  programs.kitty = {
    enable = true;
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
