{ pkgs, ... }:

let
  my-overlays = import /home/igm/dotfiles/nixos/overlays.nix;
in {
  nixpkgs.overlays = [ my-overlays ];
  nixpkgs.config.allowBroken = true;
  services.taffybar.enable = true;

  xsession.enable = !pkgs.stdenv.isDarwin;

  xsession.windowManager.xmonad = if !pkgs.stdenv.isDarwin then {
    enable = true;
    enableContribAndExtras = true;
    config = ../dotfiles/xmonad/xmonad.hs;
  } else {};
}
