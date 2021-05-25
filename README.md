# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Personal Desktop (NixOS)

Dotfiles and most program installations are managed by the [Nix package manager](https://nixos.org/nix/).

## Installation

Run `./install.sh`. This cross-platform script should set up anything relevant.

### System updates

Update the system using the following command:

```bash
sudo nixos-rebuild switch --flake "$HOME/dotfiles/private#primary"
```

### Locking

Git artifacts must be deleted before generating the flake lockfiles. Run this after committing:

```bash
git clean -fdX
nix flake lock --recreate-lock-file
```

## License

MIT
