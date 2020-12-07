echo "find . -type f -name '*.nix' | xargs nixfmt && git add ." > ./.git/hooks/pre-commit
chmod 0755 ./.git/hooks/pre-commit
