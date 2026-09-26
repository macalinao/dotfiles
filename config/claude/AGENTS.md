# Claude Code Settings

This directory contains Claude Code configuration.

## Files

- `settings.json` - Main Claude Code settings file

## Commands

### claude-config-apply

Deploys `settings.json` from this directory to all Claude config directories (`~/.claude`, `~/.claude-2`, `~/.claude-3`). Also adds required plugin marketplaces.

```bash
claude-config-apply
```

### claude-config-sync

Copies `~/.claude/settings.json` back to this directory. Use this after making changes via Claude Code that you want to persist.

```bash
claude-config-sync
```

## Settings Structure

### Permissions

The `permissions.allow` array controls which tools Claude can use without prompting. Keep permissions organized by category:

1. **Bun** - `Bash(bun ...)` commands
2. **Cargo/Rust** - `Bash(cargo ...)` commands
3. **Git/GitHub** - `Bash(git ...)` and `Bash(gh ...)` commands
4. **Filesystem** - `Bash(cat/find/ls/mkdir/mv/tail/touch/tree:*)`
5. **Search** - `Bash(ast-grep/grep/rg:*)`
6. **Other CLI** - `Bash(claude/echo/nix:*)`
7. **Web** - `WebSearch`, `WebFetch(domain:...)`
8. **MCP** - `mcp__*` tool permissions

### Other Settings

- `model` - Default model to use (e.g., "opus", "sonnet")
- `hooks` - Event hooks for notifications and automation
- `enabledPlugins` - Which Claude Code plugins are enabled
- `includeCoAuthoredBy` - Whether to add co-authored-by to commits

## Documentation

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Claude Code Settings Schema](https://json.schemastore.org/claude-code-settings.json)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)
