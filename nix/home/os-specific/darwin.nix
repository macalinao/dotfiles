{ pkgs, lib, systemConfig, ... }:

let
  isM1 = systemConfig.igm.isM1;
in
{
  home.packages = with pkgs; [
    reattach-to-user-namespace
    pinentry_mac
    gnupg
    kbfs
    ffmpeg

    pm2
  ] ++ (lib.optionals isM1 [
    keybase
  ]);

  xdg.enable = true;

  home.file.".gnupg/gpg-agent.conf" = {
    text =
      "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
  };

  programs.kitty = {
    enable = isM1;
    theme = "GitHub Dark";
    font = {
      name = "Menlo";
      size = 12;
    };
  };
}
