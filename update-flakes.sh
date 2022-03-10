#!/usr/bin/env bash

DOTFILES=$(pwd)/$(dirname $0)
cd $DOTFILES

zsh -c 'nixpkgs-fmt **/*.nix'

nix_cmd() {
  nix --extra-experimental-features flakes --extra-experimental-features nix-command $@
}

nix_cmd flake update $DOTFILES/nix
nix_cmd flake update

if $(uname -a | grep -q "Darwin"); then
  nix_cmd flake update $DOTFILES/private/flakes/darwin
else
  nix_cmd flake update $DOTFILES/private/flakes/nixos
fi

git add .
