# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository that manages system configuration across multiple machines using Nix. It supports:

- macOS systems (both Intel and ARM)
- NixOS systems

The repository uses Nix Flakes for declarative system and user environment configuration.

## Common Commands

### Applying Configuration Changes

```bash
igm-switch        # Apply changes and rebuild system configuration
```

### Updating Dependencies

```bash
igm-update        # Update all Nix flake dependencies and format code
igm-switch        # Apply the updates
```

### Development

```bash
nix fmt            # Format all files (Nix, shell, Markdown, YAML, JSON)
```

### Cachix Operations

```bash
cachix-push-m1-config  # Push M1 Darwin configuration to Cachix
```

## Architecture

### Flake Structure

The repository uses flake-parts with partitions:

- `/flake.nix`: Main flake using flake-parts
- Platform-specific inputs are isolated via partitions:
  - `nix/darwin/flake.nix`: Darwin partition inputs (nix-darwin, home-manager, nix-casks, etc.)
  - `nix/nixos/flake.nix`: NixOS partition inputs
- Private configurations (`~/dotfiles-private`) are injected at build time via `--override-input dotfiles-private`; a stub at `github:macalinao/dotfiles-private-stub` is used by default (for CI)

### Key Directories

- `/nix/`: Core Nix configurations
  - `darwin/`: macOS-specific system configuration
  - `home/`: Home Manager user environment configuration
  - `nixos/`: NixOS system configuration
  - `shells/`: Development shells for various languages
- `/scripts/`: Helper scripts (igm-\* commands)
- `/config/`: Application configurations (VSCode, Cursor, Claude Code)

### Configuration Flow

1. Configurations are defined in Nix files under `/nix/`
2. `igm-switch` builds and applies configurations based on the current platform
3. Private configurations are managed separately in `~/dotfiles-private`

## Important Notes

- Always commit changes before running `igm-switch`, as it reads from the git tree
- Always use `igm-switch` to apply configuration changes, not raw Nix commands
- The repository uses platform detection to determine which flake to use
- Run `nix fmt` before committing to format files
- Private configurations are updated automatically when running `igm-switch`

### Claude Code Settings

Claude Code settings are stored in `/config/claude/`. See [config/claude/CLAUDE.md](config/claude/CLAUDE.md) for documentation on the settings format and organization guidelines.
