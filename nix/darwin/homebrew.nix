# Contains all of my Homebrew packages.
{ config, lib, ... }:

let
  mode = config.igm.mode;
  isM1 = config.igm.isM1;
in
with lib; {
  enable = true;
  autoUpdate = true;
  cleanup = "uninstall";
  brewPrefix = if isM1 then "/opt/homebrew/bin" else "/usr/local/bin";

  taps = [
    "homebrew/bundle"
    "homebrew/cask"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
    "koekeishiya/formulae"
  ];

  brews = (lib.optionals (!isM1) [ "openssl" "openssl@1.1" ]) ++ [
    "yabai"
    "skhd"
  ];

  casks = [
    "brave-browser"
    "dashlane"
    "discord"
    "docker"
    "figma"
    "keybase"
    "kitty"
    "linear-linear"
    "ngrok"
    "notion"
    "numi"
    "postman"
    "private-internet-access"
    "slack"
    "spaceid"
    "spotify"
    "superhuman"
    "tableplus"
    "the-unarchiver"
    "zoom"
  ] ++ (lib.optionals (mode == "personal") [
    "jgrennison-openttd"
    "ledger-live"
    "minecraft"
    "signal"
    "telegram"
    "tor-browser"
    "transmission"
    "vlc"
    "wechat"
    "whatsapp"
  ]);
}
