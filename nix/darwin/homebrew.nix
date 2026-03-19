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
    "jackielii/tap"
  ];

  brews =
    (lib.optionals (!isAarch64) [
      "openssl"
      "openssl@1.1"
    ])
    ++ [
      "skhd-zig"
      "sui"
    ];

  casks = [
    "anki"
    "arc"
    "brave-browser"
    "claude"
    # "dashlane"
    "discord"
    "docker-desktop"
    "figma"
    "google-chrome"
    "keybase"
    "keymapp"
    "ngrok"
    "private-internet-access"
    "slack"
    "spaceid"
    "spotify"
    "tableplus"
    "tailscale-app"
    "the-unarchiver"
    "viber"
    "zoom"
  ]
  ++ (lib.optionals (mode == "personal") (
    [
      "google-drive"
      "ledger-wallet"
      "obsidian"
      "signal"
      "telegram"
      "whatsapp"
    ]
    ++ games
  ));
}
