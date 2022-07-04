{ config, pkgs, lib, ... }@args:

with lib;

{
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
    mplus-outline-fonts.githubRelease
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
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      keep-derivations = true;

      substituters = [
        "https://cache.nixos.org"
        "https://igm.cachix.org"
        "https://saber.cachix.org"
        "https://v.cachix.org"
        "https://s.cachix.org"
        "https://m.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "igm.cachix.org-1:JzRjOzUEP3tfmQv9hy7MP7LqaA5CEg418KKVMyJFd10="
        "saber.cachix.org-1:AmI7Ft67WCH8+JJK6+U+R7VRvuIu8vgeXHOqdhb9lHc="
        "v.cachix.org-1:34nUl7Lx9zS23llMctTkuASD1oijTxraFgZDsvy9iag="
        "s.cachix.org-1:e8AnFcja2+zuunl5f30pNY9rvj1aFcldVhIg9giRcBg="
        "m.cachix.org-1:NyJ6n2M/yLpEybD9oVf/FD96O+Nsgd5TQfIeKCFemCs="
      ];
    };
  };

  # ???
  services.logrotate.checkConfig = false;

  # keyring
  services.gnome.gnome-keyring.enable = true;
}
