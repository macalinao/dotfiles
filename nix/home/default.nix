{ systemConfig }:
{ lib, pkgs, ... }@args:

with lib;

let
  merged = args // {
    inherit systemConfig;
  };
in
mkMerge ([
  (mkIf pkgs.stdenv.isLinux
    (import ./os-specific/nixos/standard.nix merged))
  (mkIf (pkgs.stdenv.isLinux && !systemConfig.igm.headless)
    (import ./os-specific/nixos/gui.nix merged))
  (mkIf pkgs.stdenv.isDarwin (import ./os-specific/darwin.nix merged))
  (import ./dotfiles merged)
  (import ./common.nix merged)
] ++ (map (x: x merged) systemConfig.igm.homeModules))
