#!/usr/bin/env bash

set -x

DOTFILES=$(dirname $0)

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

IS_DARWIN=[ "$(uname)" = Darwin ]

if $IS_DARWIN; then
  info "Detected Darwin install."
else
  info "Detected NixOS install."
fi

read \?"Welcome to @macalinao's dotfiles installer. Press [Enter] to begin."

if $IS_DARWIN; then
  section "Install Nix and create an unencrypted nix store volume"
  if [ ! -e /nix ]; then
    # Need /usr/sbin in path
    export PATH=/usr/sbin:$PATH
    bash <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume || {
      danger "Could not install Nix"
      exit 1
    }

    # ensure nix is sourced
    . $HOME/.nix-profile/etc/profile.d/nix.sh

    # turn off spotlight on /nix
    sudo mdutil -i off /nix

    success "Nix installed"
  else
    info "Nix already installed; skipping..."
  fi
fi

if $IS_DARWIN; then
  section "Install Homebrew"
  if ! which brew; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    success "Homebrew installed"
  else
    info "Homebrew already installed, skipping..."
  fi
fi

if [ $(whoami) = igm ]; then
  section "Install Keybase"
  if $IS_DARWIN; then
    if ! $(brew list --cask | grep keybase); then
      brew cask install keybase
      read \?"Please log in to Keybase so that we can install the private dotfiles. Press [Enter] when you're done."
    fi
  else
    keybase id || {
      echo "Please authenticate with Keybase.";
      keybase login
      read \?"If you've logged in to Keybase, press [Enter]."
    };
  fi

  section "Set up private dotfiles"
  if [ ! -e ~/dotfiles-private ]; then
    git clone keybase://private/ianm/dotfiles-private ~/dotfiles-private
    success "Private dotfiles set up"
  else
    info "Private dotfiles already found. Updating..."
    cd ~/dotfiles-private && git frp
    success "Private dotfiles set up"
  fi
else
  info "User is not igm; skipping private repos setup."
fi

if $IS_DARWIN; then
  section "Install Nix configuration"
  if [ ! -e ~/.nixpkgs/darwin-configuration.nix ]; then
    sudo mv -f /etc/bashrc /etc/bashrc.orig
    sudo mv -f /etc/zshrc /etc/zshrc.orig
    mkdir -p $HOME/.nixpkgs/
    export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
    cp $DOTFILES/nix/darwin/configuration.nix.template ~/.nixpkgs/darwin-configuration.nix
    cachix use igm
    $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
    $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
    success "nix-darwin installed"
  else
    info "nix-darwin already installed, skipping..."
  fi
else
  cachix use igm
  sudo nixos-rebuild switch --flake "$HOME/dotfiles/private#primary"
fi

info "Installation complete. Please restart your shell to contine."
