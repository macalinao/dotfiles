{ pkgs, ... }:

{
  home.packages = with pkgs; [
    reattach-to-user-namespace
    pinentry_mac
    gnupg
    kbfs

    pm2
  ];

  xdg.enable = true;

  home.file.".gnupg/gpg-agent.conf" = {
    text =
      "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
  };
}
