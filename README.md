# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Personal Desktop (NixOS)

Dotfiles and most program installations are managed by the [Nix package manager](https://nixos.org/nix/).

## Installation

Run `zsh scripts/install.zsh`. This cross-platform script should set up anything relevant.

If you're on NixOS and don't have zsh installed, first run:

```
nix-shell -p zsh --command zsh
```

### Updating with flakes

```bash
sudo nixos-rebuild switch --flake "$HOME/dotfiles/private#primary"
```

## License

MIT
