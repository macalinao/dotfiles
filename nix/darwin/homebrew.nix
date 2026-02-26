# Contains all of my Homebrew packages.
{ config, lib, ... }:

let
  games = [
    "openttd"
    "league-of-legends"
    "minecraft"
    # "steam"
  ];
  mode = config.igm.mode;
  isM1 = config.igm.isM1;
in
{

  enable = true;

  onActivation = {
    cleanup = "uninstall";
    upgrade = true;
    autoUpdate = true;
  };

  prefix = if isM1 then "/opt/homebrew" else "/usr/local";

  taps = [
    "homebrew/bundle"
    # "homebrew/cask"
    "homebrew/cask-versions"
    # "homebrew/core"
    "homebrew/services"
    "asmvik/formulae"
    "jackielii/tap"
    "schpet/tap"
    "source-foundry/taproom"
  ];

  brews =
    (lib.optionals (!isM1) [
      "openssl"
      "openssl@1.1"
    ])
    ++ [
      "asmvik/formulae/yabai"
      "schpet/tap/linear"
      "skhd-zig"
      "sui"
    ];

  casks = [
    "android-studio"
    "anki"
    "arc"
    "brave-browser"
    "claude"
    # "dashlane"
    "discord"
    "docker-desktop"
    "figma"
    "ghostty"
    "google-chrome"
    "keybase"
    "keymapp"
    "linear-linear"
    "ngrok"
    "postman"
    "private-internet-access"
    "raycast"
    "slack"
    "sourcefoundry-slice"
    "spaceid"
    "spotify"
    "tableplus"
    "tailscale"
    "the-unarchiver"
    "viber"
    "zed"
    "zoom"
  ]
  ++ (lib.optionals (mode == "personal") (
    [
      "google-drive"
      "ledger-wallet"
      "obsidian"
      "signal"
      "telegram"
      "tor-browser"
      "transmission"
      "vlc"
      "wechat"
      "whatsapp"
    ]
    ++ games
  ));
}
