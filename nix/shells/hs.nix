{ pkgs }:
with pkgs;
mkShell { nativeBuildInputs = [ stack ]; }
