# Contains all of my Homebrew packages.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
  games = [
    "openttd"
    "league-of-legends"
    "minecraft"
    # "steam"
  ];
  mode = config.igm.mode;
in
{

  enable = true;

  onActivation = {
    cleanup = "uninstall";
    upgrade = true;
    autoUpdate = true;
  };

  prefix = if isAarch64 then "/opt/homebrew" else "/usr/local";

  taps = [
    "homebrew/bundle"
    # "homebrew/cask"
    "homebrew/cask-versions"
    # "homebrew/core"
    "homebrew/services"
    "acsandmann/tap"
  ];

  brews = [
    "rift"
  ];

  casks = [
    "arc"
    "claude"
    # "dashlane"
    "discord"
    "docker-desktop"
    "figma"
    "keybase"
    "linear"
    "logi-options-plus"
    "moonlight"
    "private-internet-access"
    "slack"
    "tailscale-app"
    "viber"
  ]
  ++ (lib.optionals (mode == "personal") (
    [
      "google-drive"
      "ledger-wallet"
      "whatsapp"
    ]
    ++ games
  ));
}
