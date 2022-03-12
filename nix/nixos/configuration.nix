{ config, pkgs, ... }:

{
  imports = [ ./services ./users.nix ];

  networking.hostName = "ianix";

  console = {
    keyMap = "us";
    font = "Lat2-Terminus16";
  };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  fonts.fonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    google-fonts
    liberation_ttf
    mplus-outline-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
  ];

  # This enables "fcitx" as your IME.  This is an easy-to-use IME.  It supports many different input methods.
  i18n.inputMethod.enabled = "fcitx";

  # This enables "mozc" as an input method in "fcitx".  This has a relatively
  # complete dictionary.  I recommend it for Japanese input.
  i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc hangul ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.zsh = { enable = true; };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
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

  nix = {
    package = pkgs.nixUnstable;
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

  # keyring
  services.gnome.gnome-keyring.enable = true;
}
