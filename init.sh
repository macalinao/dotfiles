echo "nixfmt **/*.nix && git add ." > ./.git/hooks/pre-commit
chmod 0755 ./.git/hooks/pre-commit
