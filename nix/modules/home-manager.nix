{ inputs, ... }:
{
  flake = {
    homeModules = {
      # Apply dotfiles' own flake inputs at eval time so the home modules close
      # over agent-skills / claude-code-nix / codex-cli-nix / shadcn-improve /
      # vercel-skills themselves. Consumers no longer need to mirror those into
      # the `inputs` they pass via extraSpecialArgs (mirrors the nixos path,
      # which already curries `{ inherit inputs; }`).
      default = import ../home/modules { inherit inputs; };
      headless = import ../home/modules/headless.nix { inherit inputs; };
    };
  };
}
