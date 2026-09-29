# Canonical Claude Code user settings (~/.claude-N/settings.json).
#
# This is the single source of truth. nix/home/dotfiles.nix renders it to a
# JSON seed for fresh installs and, minus the `runtimeOwned` keys listed
# there, re-asserts it over every instance on each activation.
#
# It used to be a checked-in config/claude/settings.json. Nix buys three
# things JSON could not: comments (the allow list below had no explanation
# anywhere), `builtins.sort` on the array-valued keys, which the activation
# merge is sensitive to (see the note on `allow`), and the option of
# per-platform or per-user values later.
#
# Not validated against https://json.schemastore.org/claude-code-settings.json
# any more, which the JSON file was — a misspelled key here fails silently at
# runtime rather than in the editor. The `$schema` key is still emitted so the
# generated file (and anything Claude rewrites from it) keeps that validation.
#
# A plain attrset, not a function: everything here is literal or `builtins`.
{
  "$schema" = "https://json.schemastore.org/claude-code-settings.json";

  # No "Co-Authored-By: Claude" trailer. Recovering this after it was lost to
  # settings drift is what motivated forcing settings at all.
  includeCoAuthoredBy = false;
  attribution = {
    commit = "";
    pr = "";
    sessionUrl = false;
  };

  outputStyle = "Concise";

  # Pre-approved tool calls, so a session does not stop to ask for things that
  # only read state. Roughly: read-only git/gh/nix queries, the bun/cargo
  # subcommands that build or test but do not publish, ordinary file reading
  # and listing, and the docs-lookup MCP tools. Anything that writes outside
  # the working tree, installs, deploys, or pushes stays unlisted on purpose.
  #
  # SORTED DELIBERATELY, and by `builtins.sort` rather than by hand. The
  # activation merge is `jq '. * $forced'`, and `*` REPLACES arrays instead of
  # merging them, so this list has to match the order Claude Code itself
  # writes — which is plain sorted. A hand-grouped ordering here (git commands
  # together, say) holds the same entries but in a different sequence, which
  # makes the merge rewrite every instance's settings.json on every
  # activation, forever. That happened; hence the sort.
  permissions = {
    allow = builtins.sort builtins.lessThan [
      "Bash(ast-grep:*)"
      "Bash(bun add:*)"
      "Bash(bun create:*)"
      "Bash(bun info:*)"
      "Bash(bun init:*)"
      "Bash(bun install:*)"
      "Bash(bun run build)"
      "Bash(bun run clean)"
      "Bash(bun run lint)"
      "Bash(bun run lint:*)"
      "Bash(bun run lint:fix)"
      "Bash(bun run test)"
      "Bash(bun run typecheck)"
      "Bash(bun run typecheck:*)"
      "Bash(bun test:*)"
      "Bash(bunx:*)"
      "Bash(cargo build:*)"
      "Bash(cargo check:*)"
      "Bash(cargo clippy:*)"
      "Bash(cargo doc:*)"
      "Bash(cargo fmt:*)"
      "Bash(cargo run:*)"
      "Bash(cat:*)"
      "Bash(claude:*)"
      "Bash(echo:*)"
      "Bash(find:*)"
      "Bash(gh issue view:*)"
      "Bash(gh pr diff:*)"
      "Bash(gh pr list:*)"
      "Bash(gh pr view:*)"
      "Bash(gh release list:*)"
      "Bash(gh release view:*)"
      "Bash(gh run list:*)"
      "Bash(gh run view:*)"
      "Bash(gh search:*)"
      # Both spellings of every read-only git query: bare, and `git -C <dir>`
      # for the other checkouts a session reaches into (the vault, dotfiles,
      # worktrees). A pattern without the `-C` form does not cover it.
      "Bash(git -C * blame:*)"
      "Bash(git -C * cat-file:*)"
      "Bash(git -C * describe:*)"
      "Bash(git -C * diff:*)"
      "Bash(git -C * log:*)"
      "Bash(git -C * ls-files:*)"
      "Bash(git -C * ls-tree:*)"
      "Bash(git -C * rev-list:*)"
      "Bash(git -C * rev-parse:*)"
      "Bash(git -C * shortlog:*)"
      "Bash(git -C * show:*)"
      "Bash(git -C * stash list:*)"
      "Bash(git -C * status:*)"
      "Bash(git blame:*)"
      "Bash(git cat-file:*)"
      "Bash(git describe:*)"
      "Bash(git diff:*)"
      "Bash(git log:*)"
      "Bash(git ls-files:*)"
      "Bash(git ls-tree:*)"
      "Bash(git rev-list:*)"
      "Bash(git rev-parse:*)"
      "Bash(git shortlog:*)"
      "Bash(git show:*)"
      "Bash(git stash list:*)"
      "Bash(git status:*)"
      "Bash(grep:*)"
      "Bash(head:*)"
      "Bash(ls:*)"
      "Bash(mkdir:*)"
      "Bash(mv:*)"
      # Evaluation and search only. `nix build`, `nix run`, `nix profile` and
      # nixos-rebuild are not here: those realise derivations or change the
      # system, and rebuilds go through scripts/devbox-switch anyway.
      "Bash(nix eval:*)"
      "Bash(nix flake show:*)"
      "Bash(nix search:*)"
      "Bash(rg:*)"
      "Bash(tail:*)"
      "Bash(touch:*)"
      "Bash(tree:*)"
      # Allocates a path in the vault and mkdir -p's its parent; writing the
      # note is a separate Write call.
      "Bash(vault-session-note:*)"
      "Bash(wc:*)"
      "WebFetch(domain:devenv.sh)"
      "WebFetch(domain:docs.anthropic.com)"
      "WebFetch(domain:github.com)"
      "WebFetch(domain:raw.githubusercontent.com)"
      "WebSearch"
      # Docs lookup, in every spelling these servers have had. The bare
      # `mcp__context7__*` / `mcp__deepwiki__*` names are from standalone MCP
      # entries; the `mcp__plugin_*` ones are the same servers reached through
      # the code-context, context7 and deepwiki plugins, which prefix the
      # plugin name. Old spellings are kept so the permission survives a
      # plugin being renamed or re-added.
      "mcp__context7__get-library-docs"
      "mcp__context7__resolve-library-id"
      "mcp__deepwiki__ask_question"
      "mcp__deepwiki__read_wiki_contents"
      "mcp__deepwiki__read_wiki_structure"
      # Navigation and clicking only — no evaluate, no file upload.
      "mcp__playwright__browser_click"
      "mcp__playwright__browser_navigate"
      "mcp__plugin_code-context_context7__query-docs"
      "mcp__plugin_code-context_context7__resolve-library-id"
      "mcp__plugin_code-context_deepwiki__ask_question"
      "mcp__plugin_code-context_deepwiki__read_wiki_contents"
      "mcp__plugin_code-context_deepwiki__read_wiki_structure"
      "mcp__plugin_context7_context7__query-docs"
      "mcp__plugin_context7_context7__resolve-library-id"
      "mcp__plugin_deepwiki_deepwiki__ask_question"
      "mcp__plugin_deepwiki_deepwiki__read_wiki_contents"
      "mcp__plugin_deepwiki_deepwiki__read_wiki_structure"
      "mcp__plugin_figma_figma__get_design_context"
      "mcp__plugin_figma_figma__get_variable_defs"
    ];
    deny = [ ];
    # permissions.additionalDirectories is deliberately absent: it is
    # per-user, so the private host module forces it. The jq merge is a deep
    # merge, so forcing `permissions` here leaves that sibling key alone.
  };

  # Commands that must not be sandboxed. Both need to reach the real git
  # config and object store (and, for signing, the gpg agent socket).
  sandbox.excludedCommands = [
    "git commit *"
    "git tag *"
  ];

  env = {
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
    ENABLE_LSP_TOOL = "1";
  };

  # Audible cue when a session wants attention: one sound when it has gone
  # idle waiting on input, a different one when it is blocked on a permission
  # prompt, so the two are distinguishable from across the room. `notifykit`
  # comes from additional-nix-packages via home.packages (see
  # modules/headless.nix), so it is on PATH for the hook.
  hooks.Notification = [
    {
      matcher = "idle_prompt";
      hooks = [
        {
          type = "command";
          command = "notifykit cchook --sound Glass";
        }
      ];
    }
    {
      matcher = "permission_prompt";
      hooks = [
        {
          type = "command";
          command = "notifykit cchook --sound Funk";
        }
      ];
    }
  ];

  # Options of installed plugins, keyed by plugin id. Built-in plugins use the
  # `@builtin` marketplace.
  pluginConfigs = {
    # Load AGENTS.md files beside CLAUDE.md, rather than the default of only
    # falling back to them in projects that have no CLAUDE.md of their own. A
    # file CLAUDE.md already imports or links is not loaded twice. Other
    # accepted values: "claude-md", "claude-md-or-agents-md" (the default),
    # "managed-only".
    "agents-md@builtin".options.instructionFiles = "claude-md-and-agents-md";
  };

  # Skip the extra confirmation on --dangerously-skip-permissions. The
  # allow list above plus the sandbox are the actual guard rails.
  skipDangerousModePermissionPrompt = true;

  # --- runtimeOwned below this line -------------------------------------
  # Claude Code writes these three from its own UI, so dotfiles.nix excludes
  # them from the forced set. They seed a fresh install and are then the
  # user's to change; a value here is a starting point, not policy.

  # /model
  model = "opus[1m]";

  # /theme
  theme = "auto";

  # /plugin. Note the drift this is protecting: chrome-devtools-mcp and
  # playwright are `true` here but toggled off on the devbox, and forcing
  # this key would turn them back on at the next switch.
  enabledPlugins = {
    "agent-sdk-dev@claude-plugins-official" = true;
    "ast-grep@ast-grep-marketplace" = true;
    "chrome-devtools-mcp@claude-plugins-official" = true;
    "code-context@igm-claude-plugins" = true;
    "code-simplifier@claude-plugins-official" = true;
    "commit-commands@claude-plugins-official" = true;
    "context7@claude-plugins-official" = true;
    "figma@claude-plugins-official" = true;
    "frontend-design@claude-plugins-official" = true;
    "github@claude-plugins-official" = true;
    "gitlab@claude-plugins-official" = true;
    "igm@igm-claude-plugins" = true;
    "notifykit@igm-claude-plugins" = true;
    "playwright@claude-plugins-official" = true;
    "plugin-dev@claude-plugins-official" = true;
    "ralph-loop@claude-plugins-official" = true;
    "slack@claude-plugins-official" = true;
  };
}
