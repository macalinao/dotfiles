{ config, pkgs, ... }:

{
  imports = [
    ./keybase.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  boot.loader.grub.device = "/dev/sda";
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "ianix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    chromium
    git
    rofi
    terminator
    transmission-gtk
    vlc
    zsh

    # Editors
    # yes I have no loyalty...
    emacs
    vim
    vscode

    # Scala
    sbt
    scala

    # Comms
    slack
    discord
    signal-desktop

    # Other
    gnupg
    haskellPackages.dhall
    haskellPackages.dhall-json
    jq
    silver-searcher
    tmux
    xclip

    # Devops
    kubernetes

    # Build
    binutils
    gcc
    gnumake
  ];

  time.timeZone = "America/Los_Angeles";

  users = {
    extraUsers = {
      igm = {
        name = "igm";
        uid = 1001;
        home = "/home/igm";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "docker"
        ];
      };
    };
  };

  # if you use pulseaudio
  nixpkgs.config.pulseaudio = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  virtualisation.docker.enable = true;
}

