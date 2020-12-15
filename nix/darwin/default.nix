{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.vim ];

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

  programs.gnupg = { agent.enable = true; };
}
