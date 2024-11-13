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
    noto-fonts-cjk
    noto-fonts-emoji
    proggyfonts
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-hangul
    ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
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

    displayManager = {
      defaultSession = "xfce";
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "igm";
      };
    };
  };
}
