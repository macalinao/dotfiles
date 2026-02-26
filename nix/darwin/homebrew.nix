# Contains all of my Homebrew packages.
{ config, lib, ... }:

let
  games = [
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

  # Casks not available in nix-casks (remaining managed by Homebrew)
  casks = [
    "google-chrome"
    "keybase"
    "keymapp"
    "private-internet-access"
    "sourcefoundry-slice"
    "spotify"
    "tailscale"
    "viber"
    "zoom"
  ]
  ++ (lib.optionals (mode == "personal") (
    [
      "google-drive"
    ]
    ++ games
  ));
}
