{ mode, isM1 ? false }:
{ config, lib, pkgs, ... }:

with lib; {
  environment.systemPackages = with pkgs; [ vim kitty tor ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.igm = import ../home;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  homebrew = {
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
    ];

    brews = lib.optionals (!isM1) [ "ethereum" "openssl" ];

    casks = [
      "brave-browser"
      "dashlane"
      "discord"
      "docker"
      "figma"
      "keybase"
      "linear-linear"
      "loom"
      "ngrok"
      "numi"
      "postman"
      "private-internet-access"
      "slack"
      "spotify"
      "superhuman"
      "tableplus"
      "the-unarchiver"
      "zoom"
    ] ++ (lib.optionals (mode == "personal") [
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
  };

  nix = {
    package = pkgs.nixUnstable;
    useSandbox = false;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    trustedUsers = [ "root" "igm" ];
  };

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    interactiveShellInit = ''
      if [ $TERM = xterm-kitty ]; then
        export TERMINFO="${pkgs.kitty}/Applications/kitty.app/Contents/Resources/kitty/terminfo";
      fi
    '';
    variables = { EDITOR = "${pkgs.vim}/bin/vim"; };
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    extraConfig = builtins.readFile ./static/yabairc;
  };

  services.lorri.enable = true;

  programs.gnupg = { agent.enable = true; };

  users.users.igm = {
    name = "Ian Macalinao";
    home = "/Users/igm";
  };
  users.nix.configureBuildUsers = true;

  launchd.user.agents.tor = {
    command = with pkgs; "${tor}/bin/tor";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "/var/tmp/tor.log";
      StandardErrorPath = "/var/tmp/tor.error.log";
    };
  };
}
