# Declarative agent skills (https://github.com/Kyure-A/agent-skills-nix).
#
# Bundles selected SKILL.md skills from flake-pinned sources and syncs them
# into the Claude Code and Codex skills directories using the `symlink-tree`
# structure (rsync -a --delete in home.activation). The module's default
# exclude pattern (`/.system`) keeps Codex's `~/.codex/skills/.system` dir
# from being deleted by the sync.
{ inputs }:
{
  config,
  lib,
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
      # Resolved by store path from dotfiles' own pin so the consumer doesn't
      # have to expose a `shadcn-improve` flake input via extraSpecialArgs.
      shadcn-improve = {
        path = inputs.shadcn-improve.outPath;
        subdir = "skills";
      };
      # github:vercel-labs/skills -> skills/find-skills
      vercel-skills = {
        path = inputs.vercel-skills.outPath;
        subdir = "skills";
      };
      # github:kepano/obsidian-skills -> skills/{defuddle,json-canvas,obsidian-bases,obsidian-cli,obsidian-markdown}
      obsidian-skills = {
        path = inputs.obsidian-skills.outPath;
        subdir = "skills";
      };
      # github:blader/humanizer -> SKILL.md lives at the repo root (no subdir),
      # so the discovered skill id is the source name `humanizer`.
      humanizer = {
        path = inputs.humanizer.outPath;
      };
      # github:apollographql/skills -> skills/rust-best-practices (and other
      # Apollo skills); only rust-best-practices is enabled below.
      apollo-skills = {
        path = inputs.apollo-skills.outPath;
        subdir = "skills";
      };
    };

    skills.enable = [
      "improve"
      "find-skills"
      "defuddle"
      "json-canvas"
      "obsidian-bases"
      "obsidian-cli"
      "obsidian-markdown"
      "humanizer"
      "rust-best-practices"
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
