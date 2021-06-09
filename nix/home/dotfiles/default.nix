{ pkgs, lib, config, ... }:

((import ./common.nix) { inherit config pkgs lib; })
