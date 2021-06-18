{ pkgs, lib, ... }:

with lib;

{
  programs.vscode = { enable = true; };
}
