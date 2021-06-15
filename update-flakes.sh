#!/usr/bin/env bash

cd $(dirname $0)
zsh -c 'nixfmt **/*.nix'
git add .

pushd nix
nix flake update
popd
nix flake update
pushd private
nix flake update
popd

git add .
