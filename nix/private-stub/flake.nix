{
  description = "Stub for dotfiles-private (used in CI where the real private repo is unavailable)";

  outputs = _: {
    darwinModules.default = { };
  };
}
