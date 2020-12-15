# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Work Desktop (Nixos)

Dotfiles and most program installations are managed by the [Nix package manager](https://nixos.org/nix/). Brew cask is used for OS X GUI programs.

## Installation

On OS X, run `scripts/init_darwin.sh`.

On NixOS, run:

1. _(NixOS only)_ Import `nixos/configuration.nix` into `/etc/nixos/configuration.nix` and run `nixos-rebuild switch`.
2. Install [Home manager](https://github.com/rycee/home-manager).
3. Clone the secrets repo at `$HOME/private_secrets`. _Obviously, if you're not me, don't do this._
4. Run `home-manager switch`.

## OS-Specific Notes

### NixOS

On NixOS (my main computer's OS), this manages all system configuration.

Notably, I've set up an HTTP ingress on my local network to allow my phone and VR headset to communicate with my main computer. This configuration can be found in `nixos/services/nginx.nix`.

### OS X

On OS X, this installs several helpful developer tools. I still install most GUI programs with `brew cask` as the Darwin support for Nix is pretty limited.

I've recently begun to experiment with [nix-darwin](https://github.com/LnL7/nix-darwin) and will begin migrating as many system services as possible to it.

Run `scripts/install_darwin.sh` to install.

## License

MIT
