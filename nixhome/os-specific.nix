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
      ledger-live-desktop
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
          # xrandr --output DVI-D-0 --off --output HDMI-0 --mode 3840x2160 --pos 3840x0 --rotate normal 
          # --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal 
          # --output DP-0 --mode 2560x1440 --pos 4596x2160 --rotate normal 
          # --output DP-1 --off --output DP-2 --mode 2560x1440 --pos 2036x2160 --rotate normal 
          # --output DP-3 --off --output DP-1-1 --mode 2560x1440 --pos 7156x2160 --rotate normal 
          # --output HDMI-1-1 --off --output HDMI-1-2 --off --output DP-1-2 --off --output HDMI-1-3 --off

          fingerprint = {
            DP-0 = "00ffffffffffff0010acf4d0563942301f1e0104b5462878fa2de5ad5045a826115054a54b008100b300d100714fa9408180d1c00101565e00a0a0a0295030203500b9882100001a000000ff00383753534634330a2020202020000000fc0044454c4c205333323230444746000000fd0030a51efa41010a202020202020010d02032df14f90050403020716010611123f13141f230907078301000065030c001000e305c000e60605096c6c2cf4fb0050a0a0285008206800b9882100001a6fc200a0a0a0555030203500b9882100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082";
            DP-1-1 = "00ffffffffffff000469a32778750100101a0104a53c22783aa595aa544fa1260a5054b7ef00d1c0b300950081808140810081c0714f565e00a0a0a029503020350055502100001a000000ff0047344c4d54463039353630380a000000fd00184c18631e04110140f838f03c000000fc00415355532050423237380a20200157020322714f0102031112130414051f900e0f1d1e2309170783010000656e0c0010008c0ad08a20e02d10103e9600555021000018011d007251d01e206e28550055502100001e011d00bc52d01e20b828554055502100001e8c0ad090204031200c40550055502100001800000000000000000000000000000000000000000096";
            DP-2 = "00ffffffffffff0010acd9414c424241191e0104b53c22783b8cb5af4f43ab260e5054a54b00d100d1c0b300a94081808100714fe1c0565e00a0a0a029503020350055502100001a000000ff00474a464d5931330a2020202020000000fc0044454c4c205332373231444746000000fd0030a5fafa41010a202020202020014b020337f1513f101f200514041312110302010607151623090707830100006d1a0000020b30a5000f623d623de305c000e606050162623ef4fb0050a0a028500820680055502100001a40e7006aa0a067500820980455502100001a6fc200a0a0a055503020350055502100001a000000000000000000000000000000000000a5";
            HDMI-0 = "00ffffffffffff000469a72890d602000d1b0103803e22783a08a5a2574fa2280f5054bfef00d1c0814081809500b30081c08100714f08e80030f2705a80b0588a006d552100001e04740030f2705a80b0588a006d552100001a000000fd00175018a03c000a202020202020000000fc0041535553204d473238550a202001ed02033df1569004031f1301125e5f60610e0f1d1e0211140522202123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a02950302035006d552100001ee26800a0a0402e60302036006d552100001ad60980a0205e63103060b20c6d552100001a000000000000000000000000b3";
            HDMI-1 = "00ffffffffffff0005e39027477702001a1e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001ee020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
          };
          config = {
            DP-2 = {
              enable = true;
              mode = "2560x1440";
              position = "2036x2160";
              rate = "165.00";
            };
            DP-0 = {
              enable = true;
              mode = "2560x1440";
              position = "4596x2160";
              rate = "165.00";
            };
            HDMI-0 = {
              enable = true;
              mode = "3840x2160";
              position = "3840x0";
              rate = "60.00";
            };
            HDMI-1 = {
              enable = true;
              mode = "3840x2160";
              position = "0x0";
              rate = "60.00";
            };
            DP-1-1 = {
              enable = true;
              mode = "2560x1440";
              position = "7156x2160";
              rate = "60.00";
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

    home.file.".gnupg/gpg-agent.conf" = {
      text = "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
    };
  })
]
