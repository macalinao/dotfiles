# Contains all of my Homebrew packages.
{ config, lib, ... }:

let
  games = [
    # "jgrennison-openttd"
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

  brewPrefix = if isM1 then "/opt/homebrew/bin" else "/usr/local/bin";

  taps = [
    "homebrew/bundle"
    # "homebrew/cask"
    "homebrew/cask-versions"
    # "homebrew/core"
    "homebrew/services"
    "koekeishiya/formulae"
    "jackielii/tap"
    "source-foundry/taproom"
  ];

  brews =
    (lib.optionals (!isM1) [
      "openssl"
      "openssl@1.1"
    ])
    ++ [
      "yabai"
      "skhd-zig"
      "sui"
    ];

  casks = [
    "android-studio"
    "anki"
    "arc"
    "brave-browser"
    "claude"
    "cloudflare-warp"
    # "dashlane"
    "discord"
    "docker-desktop"
    "figma"
    "google-chrome"
    "keybase"
    "keymapp"
    "linear-linear"
    "ngrok"
    "notion"
    "postman"
    "private-internet-access"
    "raycast"
    "slack"
    "sourcefoundry-slice"
    "spaceid"
    "spotify"
    "tableplus"
    "the-unarchiver"
    "viber"
    "zoom"
  ]
  ++ (lib.optionals (mode == "personal") (
    [
      "google-drive"
      "ledger-live"
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
