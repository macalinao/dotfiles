# Declarative agent skills (https://github.com/Kyure-A/agent-skills-nix).
#
# Bundles selected SKILL.md skills from flake-pinned sources and syncs them
# into the Claude Code and Codex skills directories. We use the `link`
# structure (home.file symlinks) rather than the default `symlink-tree`
# (rsync --delete) so that skills installed by hand (e.g. `npx skills add`)
# alongside the Nix-managed ones are never clobbered.
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
          dest = ".claude-${n}/skills";
          structure = "link";
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
        structure = "link";
      };
      codex = {
        enable = true;
        structure = "link";
      };
    }
    // instanceTargets;
  };
}
