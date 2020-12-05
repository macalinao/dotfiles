#!/usr/bin/env bash

echo "nixfmt **/*.nix && git add ." > ./.git/hooks/pre-commit
