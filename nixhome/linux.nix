{ pkgs, ... }:

{
  # xsession.enable = true;

  xsession.windowManager.xmonad = if !pkgs.stdenv.isDarwin then {
    enable = true;
    enableContribAndExtras = true;
    config = ../dotfiles/xmonad/xmonad.hs;
  } else {};
}
