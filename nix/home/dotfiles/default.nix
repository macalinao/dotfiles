{ pkgs, lib, config, ... }:

lib.mkMerge [
  ((import ./common.nix) { inherit config pkgs lib; })
  { home.file = pkgs.dotfiles-private.homeFiles; }
]
