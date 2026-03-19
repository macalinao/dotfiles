{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  environment.systemPackages = with pkgs; [
    vim
    ghostty-bin
    zed-editor

    # macOS apps via nix-casks (in systemPackages for Spotlight indexing)
    nix-casks.linear-linear
    nix-casks.notion
    nix-casks.transmission
    nix-casks.vlc

  ];

  home-manager.users.igm = {
    imports = [ ../home ];

  };
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

  homebrew = import ./homebrew.nix { inherit config lib pkgs; };

  # nix.configureBuildUsers = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    variables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
  };

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
    };
    extraConfig = ''
      yabai -m rule --add app="^Simulator" manage=off
      yabai -m rule --add app="^qemu-system-aarch64" manage=off
    '';
  };

  programs.gnupg.agent.enable = true;

  users.users.igm = {
    name = "igm";
    home = "/Users/igm";
    shell = pkgs.zsh;
  };
}
