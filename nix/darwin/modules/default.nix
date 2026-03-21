{ inputs }:

let
  inherit (inputs)
    self
    home-manager
    nix-index-database
    additional-nix-packages
    nix-casks
    ;
in
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../system.nix
    ../../nix-settings.nix
    nix-index-database.darwinModules.nix-index
    home-manager.darwinModules.home-manager
  ];

  igm.mode = "personal";

  nixpkgs = import ../../nixpkgs/config.nix {
    isDarwin = true;
    additionalOverlays = [
      (self: super: {
        additional-nix-packages = additional-nix-packages.packages.${self.stdenv.hostPlatform.system};
      })
      (self: super: {
        nix-casks = nix-casks.packages.${self.stdenv.hostPlatform.system};
      })
    ];
  };

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
    imports = [ self.homeModules.default ];
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

  homebrew = import ../homebrew.nix { inherit config lib pkgs; };

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
