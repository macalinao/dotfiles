{ pkgs, ... }:

{
  home.packages = with pkgs; [ reattach-to-user-namespace pinentry_mac gnupg ];

  home.file.".gnupg/gpg-agent.conf" = {
    text =
      "pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.passthru.binaryPath}";
  };
}
