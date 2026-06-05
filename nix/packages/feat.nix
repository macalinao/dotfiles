{
  writeTextDir,
  git-worktree-runner,
}:

# Sourceable shell snippet exposing `feat <name>`:
#   feat my-thing       → gtr new $prefix/my-thing && cd ../$prefix-my-thing
#   feat someone/thing  → gtr new someone/thing && cd ../someone-thing
# Must be a shell function (not a binary) so the trailing `cd` affects the
# caller's shell. The branch prefix resolves as GIT_BRANCH_PREFIX, then
# GITHUB_USERNAME, then `macalinao` (e.g. CI / stub profile). Both env vars
# come from profile-env (dotfiles-private); GIT_BRANCH_PREFIX lets a profile
# decouple its branch namespace from its GitHub username.
writeTextDir "share/feat/feat.zsh" ''
  feat() {
    if [[ -z "$1" ]]; then
      echo "Usage: feat <feature-name>"
      return 1
    fi
    local branch="$1"
    case "$branch" in
      */*) ;;
      *) branch="''${GIT_BRANCH_PREFIX:-''${GITHUB_USERNAME:-macalinao}}/$branch" ;;
    esac
    ${git-worktree-runner}/bin/gtr new "$branch" && cd "../''${branch//\//-}"
  }
''
