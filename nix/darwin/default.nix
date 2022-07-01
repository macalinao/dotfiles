{ config, lib, pkgs, ... }:

let
  mode = config.igm.mode;
  isM1 = config.igm.isM1;
in
with lib; {
  environment.systemPackages = with pkgs; [ vim tor ];

  home-manager.users.igm = import ../home { systemConfig = config; };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  system.defaults = {
    dock = {
      mru-spaces = false;
      autohide = true;
      tilesize = 32;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  homebrew = import ./homebrew.nix { inherit config lib; };

  nix = {
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
      unset TERMINFO
      if [ $TERM = xterm-kitty ]; then
        export TERMINFO="/Applications/kitty.app/Contents/Resources/kitty/terminfo";
      fi
    '';
    variables = {
      EDITOR = "${pkgs.vim}/bin/vim";
    };
  };

  programs.gnupg = { agent.enable = true; };

  users.users.igm = {
    name = "igm";
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
