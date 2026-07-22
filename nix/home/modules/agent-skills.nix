# Declarative agent skills.
#
# The curated skill bundle and all its upstream sources now live in a standalone
# flake (github:macalinao/my-agent-skills), which exposes a home-manager module
# that syncs the skills into the Claude Code and Codex skills directories. This
# module is a thin wrapper that imports it and mirrors the number of Claude
# instance dirs created in dotfiles.nix so every instance gets the same skills.
{ inputs }:
{
  config,
  ...
}:
{
  imports = [ inputs.my-agent-skills.homeManagerModules.default ];

  # Mirror the .claude .. .claude-N instance dirs (~/.claude-2/skills, ...) so
  # every Claude instance gets the same skills.
  myAgentSkills.claudeInstances = config.igm.claudeInstances;
}
