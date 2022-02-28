#!/usr/bin/env bash

DOTFILES=$(pwd)/$(dirname $0)
cd $DOTFILES

zsh -c 'nixfmt **/*.nix'

nix flake update $DOTFILES/nix
nix flake update

if $(uname -a | grep -q "Darwin"); then
    nix flake update $DOTFILES/private/flakes/darwin
else
    nix flake update $DOTFILES/private/flakes/nixos
fi

git add .
