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
igm-fmt           # Format all files (Nix, shell, Markdown, YAML, JSON)
igm-fmt-check     # Check formatting without modifying files (used in CI)
```

### Cachix Operations

```bash
cachix-push-m1-config  # Push M1 Darwin configuration to Cachix
```

## Architecture

### Flake Structure

The repository uses a multi-flake architecture:

- `/nix/flake.nix`: Main system configuration flake
- Platform-specific flakes are located in:
  - `~/dotfiles-darwin` (macOS)
  - `./private/flakes/nixos` (NixOS)

### Key Directories

- `/nix/`: Core Nix configurations
  - `darwin/`: macOS-specific system configuration
  - `home/`: Home Manager user environment configuration
  - `nixos/`: NixOS system configuration
  - `shells/`: Development shells for various languages
  - `private/`: Private configuration management
- `/scripts/`: Helper scripts (igm-\* commands)
- `/config/`: Application configurations (VSCode, Cursor)

### Configuration Flow

1. Configurations are defined in Nix files under `/nix/`
2. `igm-switch` builds and applies configurations based on the current platform
3. Private configurations are managed separately in `~/dotfiles-private`

## Important Notes

- Always use `igm-switch` to apply configuration changes, not raw Nix commands
- The repository uses platform detection to determine which flake to use
- Run `igm-fmt` before committing to format Nix files
- Private configurations are updated automatically when running `igm-switch`

### Claude Code Settings

Claude Code settings are stored in `/config/claude/`. See [config/claude/CLAUDE.md](config/claude/CLAUDE.md) for documentation on the settings format and organization guidelines.
