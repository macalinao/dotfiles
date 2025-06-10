{
  pkgs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    coreutils-full
    nixfmt-rfc-style
    shfmt
    biome
  ];

  languages.nix = {
    enable = true;
  };

  # https://devenv.sh/languages/
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_22;
    bun.enable = true;
    pnpm = {
      enable = true;
      package = pkgs.pnpm.override {
        nodejs = pkgs.nodejs_22;
      };
    };
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    # Format shell scripts
    shfmt.enable = true;
    # Format JavaScript/TypeScript/JSON/CSS files with Biome
    biome = {
      enable = true;
      files = "\.(js|jsx|ts|tsx|css|graphql|jsonc)$";
      excludes = [ "config/.*\\.json$" ];
    };
    # Run prettier on other files that Biome doesn't support
    prettier = {
      enable = true;
      files = "\.(md|html|yml|yaml|json)$";
    };
  };
}
