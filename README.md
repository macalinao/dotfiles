# dotfiles

Common configuration files across my machines.

These files apply to several machines:

- Personal Laptop (OSX)
- Work Laptop (OSX)
- Personal Desktop (NixOS)

Dotfiles and most program installations are managed by the [Nix package manager](https://nixos.org/nix/).

## Installation

Run [`./install.sh`](./install.sh). This cross-platform script should set up anything relevant.

You may want to manually step through the install script yourself in case of failure.

### Applying changes

After modifying a Nix configuration, run:

```bash
igm-system
```

This will apply your changes. It does not update Nixpkgs-- to do this read the next section.

### Updating Nixpkgs and other upstream dependencies

First, update all Flake dependencies using:

```bash
igm-update
```

Then, to apply the changes, use the command:

```bash
igm-update
```

### Locking

Git artifacts must be deleted before generating the Flake lock files. Run this after committing:

```bash
git clean -fdX
nix flake lock --recreate-lock-file
```

## License

MIT
