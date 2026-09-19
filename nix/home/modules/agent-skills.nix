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

  # Mirror the .claude-1 .. .claude-N instance dirs so every Claude
  # instance gets the same skills.
  #
  # numberedFirstInstance is set because instance 1 is an ordinary
  # numbered dir here: CLAUDE_CONFIG_DIR pins bare `claude` to
  # ~/.claude-1, so nothing reads the default ~/.claude scope and syncing
  # it would just rebuild a tree no session loads.
  myAgentSkills = {
    claudeInstances = config.igm.claudeInstances;
    numberedFirstInstance = true;
  };

  # The sync is `rsync --delete`, so anything in a skills dir that isn't in
  # the bundle gets wiped. Keep the upstream default (Codex's `.system`) and
  # add `synced`, where Claude Code stores skills synced from claude.ai.
  programs.agent-skills.excludePatterns = [
    "/.system"
    "/synced"
  ];
}
