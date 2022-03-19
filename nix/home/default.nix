{ systemConfig }:
{ lib, pkgs, ... }@args:

with lib;
mkMerge [
  (mkIf pkgs.stdenv.isLinux
    (import ./os-specific/nixos/standard.nix args))
  (mkIf (pkgs.stdenv.isLinux && !systemConfig.igm.headless)
    (import ./os-specific/nixos/gui.nix args))
  (mkIf pkgs.stdenv.isDarwin (import ./os-specific/darwin.nix args))
  (import ./dotfiles args)
  (import ./common.nix args)
]
