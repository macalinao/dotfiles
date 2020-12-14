{ config, pkgs, ... }:

{
  environment.systemPackages =
    [ pkgs.vim
    ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  programs.zsh.enable = true;  # default shell on catalina

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    # enableScriptingAddition = true;
    extraConfig = builtins.readFile ./static/yabairc;
  };
}
