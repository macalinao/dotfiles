#!/usr/bin/env bash

DOTFILES=$(dirname $0)/..

bold="$(tput bold)"
unbold=$(tput sgr0)
section() {
  echo "👉 ${bold}$1${unbold}"
}

danger() {
  echo "❌ $(tput setaf 1)$1$(tput setaf 0)"
}

success() {
  echo "✅ $(tput setaf 2)$1$(tput setaf 0)"
}

info() {
  echo "ℹ️  $1"
}

section "Install Nix and create an unencrypted nix store volume"
# Need /usr/sbin in path
if [ ! -e /nix ]; then

export PATH=/usr/sbin:$PATH
bash <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume || {
  danger "Could not install Nix"
  exit 1
}
success "Nix installed"
# turn off spotlight on /nix
sudo mdutil -i off /nix

else
  info "Nix already installed; skipping..."
fi
. $HOME/.nix-profile/etc/profile.d/nix.sh

section "Add various nix channels"
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
nix-channel --update
success "Nix channels added and updated"

section "Install nix-darwin"
if [ ! -e ~/.nixpkgs/darwin-configuration.nix ]; then
sudo mv -f /etc/bashrc /etc/bashrc.orig
sudo mv -f /etc/zshrc /etc/zshrc.orig
export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
cp $DOTFILES/nix/darwin/configuration.nix.template ~/.nixpkgs/darwin-configuration.nix
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
success "nix-darwin installed"

else
  info "nix-darwin already installed, skipping..."
fi

section "Install Home Manager"
if ! which home-manager; then
NIX_HOME_CONFIG=$HOME/.config/nixpkgs/home.nix
if [ -e $HOME/.zshrc ]; then
  mv $HOME/.zshrc $HOME/zshrc_old.zsh
fi
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install || {
  danger "Could not install home-manager"
  exit 1
}
cp $DOTFILES/nix/home/home.nix.template $NIX_HOME_CONFIG
home-manager switch
else
  info "Home manager already installed, skipping..."
fi

section "Install Homebrew"
if ! which brew; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  info "Homebrew already installed, skipping..."
fi

