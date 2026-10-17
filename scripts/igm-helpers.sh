# Common helper functions for my dotfiles scripts.

# Runs the Nix command without requiring flakes to be enabled.
nix_cmd() {
  nix --extra-experimental-features flakes --extra-experimental-features nix-command $@
}
