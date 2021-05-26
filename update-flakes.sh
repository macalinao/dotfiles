#!/usr/bin/env bash

cd $(dirname $0)
git add .

nix flake lock --update-input igm
pushd private
nix flake lock --update-input igm
popd

git add .
