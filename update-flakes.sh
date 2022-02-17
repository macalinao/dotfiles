#!/usr/bin/env bash

DOTFILES=$(pwd)/$(dirname $0)
cd $DOTFILES

zsh -c 'nixfmt **/*.nix'

nix flake update $DOTFILES/nix
nix flake update
nix flake update $DOTFILES/private/flakes/darwin
nix flake update $DOTFILES/private/flakes/nixos

git add .
