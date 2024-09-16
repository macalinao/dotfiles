{ config, lib, pkgs, ... }:

let
  homeBase = import ../home { systemConfig = config; };
  mode = config.igm.mode;
in
with lib; {
  environment.systemPackages = with pkgs; [
    vim
    # Tor install is currently broken 2023-11-28
    # tor
  ];

  home-manager.users.igm = homeBase;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

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
    configureBuildUsers = true;
    settings = {
      sandbox = false;
      trusted-users = [ "root" "igm" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

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
