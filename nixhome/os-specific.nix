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
      hyper
      insomnia
      postman

      # Etc
      rofi
      rofi-systemd

      # Video
      ffmpeg
      handbrake

      libreoffice

      # games
      factorio
      minecraft
      openttd

      image_optim
      bitwig-studio
      keybase-gui
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
        la = {
          fingerprint = {
            DP-1-1 = "00ffffffffffff0010acd9414c424241191e0104b53c22783b8cb5af4f43ab260e5054a54b00d100d1c0b300a94081808100714fe1c0565e00a0a0a029503020350055502100001a000000ff00474a464d5931330a2020202020000000fc0044454c4c205332373231444746000000fd0030a5fafa41010a202020202020014b020337f1513f101f200514041312110302010607151623090707830100006d1a0000020b30a5000f623d623de305c000e606050162623ef4fb0050a0a028500820680055502100001a40e7006aa0a067500820980455502100001a6fc200a0a0a055503020350055502100001a000000000000000000000000000000000000a5";
            HDMI-0 = "00ffffffffffff000469a72890d602000d1b0103803e22783a08a5a2574fa2280f5054bfef00d1c0814081809500b30081c08100714f08e80030f2705a80b0588a006d552100001e04740030f2705a80b0588a006d552100001a000000fd00175018a03c000a202020202020000000fc0041535553204d473238550a202001ed02033df1569004031f1301125e5f60610e0f1d1e0211140522202123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a02950302035006d552100001ee26800a0a0402e60302036006d552100001ad60980a0205e63103060b20c6d552100001a000000000000000000000000b3";
          };
          # xrandr --output DP-1-1 --mode 2560x1440 --primary --rotate normal --rate 165 --auto --output HDMI-0 --mode 3840x2160 --right-of DP-1-1 --auto --rotate normal
          config = {
            DP-1-1 = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "165.00";
            };
            DP-0 = {
              enable = true;
              mode = "2560x1440";
              position = "2560x0";
              rate = "165.00";
              primary = true;
            };
            HDMI-0 = {
              enable = true;
              mode = "3840x2160";
              position = "1920x1440";
              rate = "60.00";
            };
            HDMI-1 = {
              enable = true;
              mode = "2560x1440";
              position = "5120x0";
              rate = "60.00";
            };
          };
        };
      };
    };

          xrandr --output DP-1-1 --mode 2560x1440 --primary --rotate normal --rate 165 --auto
          --output HDMI-0 --mode 3840x2160 --right-of DP-1-1 --auto --rotate normal

  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.packages = with pkgs; [
      reattach-to-user-namespace
      pinentry_mac
    ];

    home.file.".gnupg/gpg-agent.conf" = {
      text = "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
    };
  })
]
