{
  config,
  lib,
  pkgs,
  ...
}@args:

{
  fonts.packages = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    google-fonts
    liberation_ttf
    mplus-outline-fonts.githubRelease
    noto-fonts
    noto-fonts-emoji
    proggyfonts
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-hangul
    ];
  };

  # Enable sound with PulseAudio (disable PipeWire).
  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services.xserver = {
    enable = true;
    dpi = 96;

    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
      };
    };

    displayManager.lightdm.enable = true;
  };

  services.displayManager = {
    defaultSession = "xfce";
    autoLogin = {
      enable = true;
      user = "igm";
    };
  };
}
