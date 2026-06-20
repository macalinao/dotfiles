# Declarative agent skills (https://github.com/Kyure-A/agent-skills-nix).
#
# Bundles selected SKILL.md skills from flake-pinned sources and syncs them
# into the Claude Code and Codex skills directories using the `symlink-tree`
# structure (rsync -a --delete in home.activation). The module's default
# exclude pattern (`/.system`) keeps Codex's `~/.codex/skills/.system` dir
# from being deleted by the sync.
{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.igm;

  # Mirror the .claude-2 .. .claude-N instance dirs created in dotfiles.nix so
  # every Claude instance gets the same skills.
  instanceTargets = builtins.listToAttrs (
    builtins.genList (
      i:
      let
        n = toString (i + 2);
      in
      {
        name = "claude-${n}";
        value = {
          enable = true;
          dest = "$HOME/.claude-${n}/skills";
          structure = "symlink-tree";
        };
      }
    ) (cfg.claudeInstances - 1)
  );
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  programs.agent-skills = {
    enable = true;

    sources = {
      # github:shadcn/improve -> skills/improve
      shadcn-improve = {
        input = "shadcn-improve";
        subdir = "skills";
      };
      # github:vercel-labs/skills -> skills/find-skills
      vercel-skills = {
        input = "vercel-skills";
        subdir = "skills";
      };
    };

    skills.enable = [
      "improve"
      "find-skills"
    ];

    targets = {
      claude = {
        enable = true;
        structure = "symlink-tree";
      };
      codex = {
        enable = true;
        structure = "symlink-tree";
      };
    }
    // instanceTargets;
  };
}
