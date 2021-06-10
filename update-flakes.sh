#!/usr/bin/env bash

cd $(dirname $0)
zsh -c 'nixfmt **/*.nix'
git add .

nix flake lock --update-input igm
pushd private
nix flake lock --update-input igm
nix flake lock --update-input dotfiles-private-raw
popd

git add .
