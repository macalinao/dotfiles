{
  description = "Development-only inputs";

  inputs = {
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = _: { };
}
