{ pkgs, ... }:

{
  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 24 * 60 * 60;
    enableSshSupport = true;
  };

  programs.home-manager = {
    enable = true;
  };
}
