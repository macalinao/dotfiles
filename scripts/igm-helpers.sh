# Common helper functions for my dotfiles scripts.

# Gets the path of the configuration flake.
flake_path() {
  FLAKE_PATH=''
  if $(uname -a | grep -q "Darwin"); then
    FLAKE_PATH="$HOME/dotfiles-darwin"
  elif $(uname -a | grep -q "NixOS"); then
    FLAKE_PATH="./private/flakes/nixos"
  else
    echo "No system flake found for this platform."
    exit 1
  fi
  echo $FLAKE_PATH
}

# Gets the attribute of the flake to build for the system configuration.
system_config_attribute() {
  if $(uname -a | grep -q "Darwin"); then
    echo "darwinConfigurations.$(hostname).system"
  elif $(uname -a | grep -q "NixOS"); then
    hostname
  else
    echo "No system flake found for this platform."
    exit 1
  fi
}

# Runs the Nix command without requiring flakes to be enabled.
nix_cmd() {
  nix --extra-experimental-features flakes --extra-experimental-features nix-command $@
}
