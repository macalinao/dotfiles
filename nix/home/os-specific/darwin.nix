{
  pkgs,
  lib,
  systemConfig,
  config,
  ...
}:

let
  isM1 = systemConfig.igm.isM1;
in
{
  home.packages =
    with pkgs;
    [
      reattach-to-user-namespace
      pinentry_mac
      gnupg
      kbfs

      # Used for Thorium/Animecards
      ffmpeg

      pm2
    ]
    ++ (lib.optionals isM1 [
      keybase
    ]);

  xdg.enable = true;

  home.file.".gnupg/gpg-agent.conf" = {
    text = "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
  };

  programs.zsh.sessionVariables.ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
}
