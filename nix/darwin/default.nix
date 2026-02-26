{
  config,
  lib,
  pkgs,
  ...
}:

let
  homeBase = import ../home { systemConfig = config; };
  mode = config.igm.mode;
  casks = pkgs.nix-casks;
in
with lib;
{
  environment.systemPackages =
    with pkgs;
    [
      vim

      # macOS apps via nix-casks (in systemPackages for Spotlight indexing)
      casks."android-studio"
      casks.anki
      casks.arc
      casks."brave-browser"
      casks.claude
      casks.discord
      casks."docker-desktop"
      casks.figma
      casks.ghostty
      casks."linear-linear"
      casks.ngrok
      casks.notion
      casks.postman
      casks.raycast
      casks.slack
      casks.spaceid
      casks.tableplus
      casks."the-unarchiver"
      casks.zed
    ]
    ++ (optionals (mode == "personal") [
      casks."ledger-wallet"
      casks.obsidian
      casks.signal
      casks.telegram
      casks."tor-browser"
      casks.transmission
      casks.vlc
      casks.wechat
      casks.whatsapp
      casks.openttd
    ]);

  home-manager.users.igm = homeBase;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  system.primaryUser = "igm";
  system.defaults = {
    dock = {
      mru-spaces = false;
      autohide = true;
      tilesize = 32;
    };
  };

  system.stateVersion = 5;
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
  ids.gids.nixbld = 30000;

  homebrew = import ./homebrew.nix { inherit config lib; };

  nix = {
    # configureBuildUsers = true;
    settings = {
      sandbox = false;
      trusted-users = [
        "root"
        "igm"
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    variables = {
      EDITOR = "${pkgs.vim}/bin/vim";
    };
  };

  programs.gnupg.agent.enable = true;

  users.users.igm = {
    name = "igm";
    home = "/Users/igm";
  };

  # Tor broken 2023-11-28
  # launchd.user.agents.tor = {
  #   command = with pkgs; "${tor}/bin/tor";
  #   serviceConfig = {
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     ProcessType = "Background";
  #     StandardOutPath = "/var/tmp/tor.log";
  #     StandardErrorPath = "/var/tmp/tor.error.log";
  #   };
  # };
}
