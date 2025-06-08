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
IS_ARM64=[[ $(uname -a) = *"arm64"* ]]

if $IS_DARWIN; then
	if $IS_ARM64; then
		info "Detected Darwin (Intel) install."
	else
		info "Detected Darwin (arm64) install."
	fi
else
	info "Detected NixOS install."
fi

read \?"Welcome to @macalinao's dotfiles installer. Press [Enter] to begin."

if $IS_DARWIN; then
	section "Install Nix and create an unencrypted nix store volume"
	if [ ! -e /nix ]; then
		# Need /usr/sbin in path
		export PATH=/usr/sbin:$PATH
		bash <(curl -L https://nixos.org/nix/install) || {
			danger "Could not install Nix"
			exit 1
		}

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
	if [ $IS_DARWIN && $IS_ARM64 ]; then
		if /usr/bin/pgrep oahd >/dev/null 2>&1; then
			echo "Rosetta is already installed and running. Nothing to do."
		else
			softwareupdate –-install-rosetta –-agree-to-license
		fi
		if ! $(brew list | grep keybase); then
			brew install keybase
			read \?"Please log in to Keybase so that we can install the private dotfiles. Press [Enter] when you're done."
		fi
	else
		keybase id || {
			echo "Please authenticate with Keybase."
			keybase login
			read \?"If you've logged in to Keybase, press [Enter]."
		}
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

section "Setup temporary Cachix"
nix-env -iA cachix -f https://cachix.org/api/v1/install
nix-env --set-flag priority 100 cachix
cachix use igm

if $IS_DARWIN; then
	section "Install Nix configuration"

	DOTFILES_SYSTEM_ATTR=ian-mbp
	if $IS_ARM64; then
		DOTFILES_SYSTEM_ATTR=ian-mbp-m1
	fi

	nix build --extra-experimental-features nix-command --extra-experimental-features flakes $DOTFILES/private/flakes/darwin#darwinConfigurations.$DOTFILES_SYSTEM_ATTR.system
	./result/sw/bin/darwin-rebuild switch --flake $DOTFILES/private/flakes/darwin
	success "nix-darwin installed"
else
	sudo nixos-rebuild switch --flake "$HOME/dotfiles/private/flakes/nixos#primary"
fi

info "Installation complete. Please restart your shell to contine."
