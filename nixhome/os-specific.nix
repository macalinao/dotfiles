{ config, pkgs, lib, ... }:

lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux {
    xsession.enable = true;

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ../dotfiles/xmonad/xmonad.hs;
    };

    home.packages = with pkgs; [
      # random
      glxinfo

      # Browsers
      brave
      chromium
      firefox
      google-chrome
      (callPackage ./programs/cypress.nix {})

      # Media
      spotify
      vlc

      # Comms
      slack
      discord
      signal-desktop
      zoom-us

      # Developer
      hyper
      insomnia

      # Etc
      rofi
      rofi-systemd

      # Video
      ffmpeg
      handbrake

      # analysis
      (import ./programs/jupyter.nix)

      libreoffice

      # games
      factorio
      wine
      winetricks
      league-of-legends
      minecraft
      openttd

      image_optim
    ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 24 * 60 * 60;
      maxCacheTtl = 24 * 60 * 60;
      enableSshSupport = true;
    };

    services.xscreensaver.enable = true;

    programs.autorandr = {
      enable = true;
      profiles = {
        main = {
          fingerprint = {
            DP-1-1 = "00ffffffffffff000469a72857430000281b0104b53e22783b08a5a2574fa2280f5054a12800d1c0814081809500b30081c0810001014dd000a0f0703e80302035006d552100001aa36600a0f0701f80302035006d552100001a000000fd00283c86863c010a202020202020000000fc0041535553204d473238550a20200195020314714702030405900e0f2309170783010000565e00a0a0a02950302035006d552100001ee26800a0a0402e60302036006d552100001ad60980a0205e63103060b20c6d552100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fd";
            DP-2 = "00ffffffffffff000469a72890d602000d1b0104b53e22783b08a5a2574fa2280f5054a12800d1c0814081809500b30081c0810001014dd000a0f0703e80302035006d552100001aa36600a0f0701f80302035006d552100001a000000fd00283c86863c010a202020202020000000fc0041535553204d473238550a202001e2020314714702030405900e0f2309170783010000565e00a0a0a02950302035006d552100001ee26800a0a0402e60302036006d552100001ad60980a0205e63103060b20c6d552100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fd";
          };
          # xrandr --output DP-2 --mode 3840x2160 --primary --rotate left --auto --output DP-1-1 --mode 3840x2160 --left-of DP-2 --auto --rotate normal
          config = {
            DP-1-1 = {
              enable = true;
              mode = "3840x2160";
              position = "0x0";
              rate = "60.00";
            };
            DP-2 = {
              enable = true;
              mode = "3840x2160";
              position = "3840x0";
              primary = true;
              rate = "60.00";
              rotate = "left";
            };
          };
        };
      };
    };

  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      reattach-to-user-namespace
      pinentry_mac
    ];
  })
]
