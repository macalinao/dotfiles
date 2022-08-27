{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # rust stuff
    openssl
    pkgconfig
    udev

    # Etc
    rofi-systemd

    # scripts
    ngrok
    vagrant

    # for xmonad
    haskell-language-server
    cabal-install
    stack
    ghc

    home-assistant-cli
    usbutils

    keybase
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 24 * 60 * 60;
    maxCacheTtl = 24 * 60 * 60;
    enableSshSupport = true;
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;
}
