# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Work Desktop (Nixos)

Dotfiles are managed by the [Nix package manager](https://nixos.org/nix/) -- there is no (stateful) symlinking involved in the installation process.

## Installation

1. _(NixOS only)_ Import `nixos/configuration.nix` into `/etc/nixos/configuration.nix` and run `nixos-rebuild switch`.
2. _(OSX only)_ Install the [Nix package manager](https://nixos.org/nix/).
3. Install [Home manager](https://github.com/rycee/home-manager).
4. Clone the secrets repos at `$HOME/abacus_secrets` and `$HOME/private_secrets`. _Obviously, if you're not me, don't do this._
5. Run `home-manager switch`.

## OS-Specific Notes

### Nixos

On NixOS (my main computer's OS), this manages all system configuration.

Notably, I've set up an HTTP ingress on my local network to allow my phone and VR headset to communicate with my main computer. This configuration can be found in `nixos/services/nginx.nix`.

### OS X

On OS X, this installs several helpful developer tools. I still install most GUI programs with `brew cask` as the Darwin support for Nix is pretty limited.

## License

MIT
