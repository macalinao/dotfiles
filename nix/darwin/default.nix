{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vim ];

  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
    dina-font
    fira-code
    fira-code-symbols
    google-fonts
    liberation_ttf
    mplus-outline-fonts
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  nix.package = pkgs.nix;

  programs.bash.enable = true;
  programs.zsh.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    extraConfig = builtins.readFile ./static/yabairc;
  };

  services.lorri.enable = true;
}
