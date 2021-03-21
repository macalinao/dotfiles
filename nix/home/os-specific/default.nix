{ config, pkgs, lib, ... }:

lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux
    (import ./nixos.nix { inherit config pkgs lib; }))
  (lib.mkIf pkgs.stdenv.isDarwin (import ./darwin.nix { inherit pkgs; }))
]
