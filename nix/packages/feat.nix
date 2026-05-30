{
  writeTextDir,
  git-worktree-runner,
}:

# Sourceable shell snippet exposing `feat <name>`:
#   feat my-thing       → gtr new $GITHUB_USERNAME/my-thing && cd ../$GITHUB_USERNAME-my-thing
#   feat someone/thing  → gtr new someone/thing && cd ../someone-thing
# Must be a shell function (not a binary) so the trailing `cd` affects the
# caller's shell. GITHUB_USERNAME comes from profile-env (dotfiles-private);
# falls back to `macalinao` when unset (e.g. CI / stub profile).
writeTextDir "share/feat/feat.zsh" ''
  feat() {
    if [[ -z "$1" ]]; then
      echo "Usage: feat <feature-name>"
      return 1
    fi
    local branch="$1"
    case "$branch" in
      */*) ;;
      *) branch="''${GITHUB_USERNAME:-macalinao}/$branch" ;;
    esac
    ${git-worktree-runner}/bin/gtr new "$branch" && cd "../''${branch//\//-}"
  }
''
