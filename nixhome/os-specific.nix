{ pkgs, lib, ... }:

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
      (callPackage ./programs/jx.nix {})

      # Media
      spotify
      vlc

      # Comms
      slack
      discord
      signal-desktop
      zoom-us

      # Developer
      terminator

      # Etc
      rofi
    ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 24 * 60 * 60;
      maxCacheTtl = 24 * 60 * 60;
      enableSshSupport = true;
    };

    services.xscreensaver.enable = true;
  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      reattach-to-user-namespace
    ];
  })
]
