{
  config,
  pkgs,
  lib,
  ...
}@args:

with lib;

{
  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh = {
    enable = true;
  };

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  hardware.keyboard.zsa.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

  environment.variables.EDITOR = "vim";
  environment.systemPackages = with pkgs; [
    git
    zsh
    vim

    # Other
    gnupg
    xclip

    # Build
    binutils
    gcc
    gnumake

    xscreensaver
    tmux

    polybarFull
    pciutils

    tailscale
  ];

  time.timeZone = "America/Chicago";

  # ???
  services.logrotate.checkConfig = false;

  # keyring
  services.gnome.gnome-keyring.enable = true;
}
