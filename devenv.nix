{
  pkgs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    coreutils-full
    nixfmt
    shfmt
    biome
    stylua
    nodejs_24
  ];

  languages.nix = {
    enable = true;
  };

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt.enable = true;
    # Format shell scripts with 2-space indent
    shfmt = {
      enable = true;
      entry = "${pkgs.shfmt}/bin/shfmt -i 2 -w";
    };
    # Format JavaScript/TypeScript/JSON/CSS files with Biome
    biome = {
      enable = true;
      files = "\.(js|jsx|ts|tsx|css|graphql|jsonc)$";
      excludes = [ "config/.*\\.json$" ];
    };
    # Format Lua files with stylua
    stylua = {
      enable = true;
    };
    # Run prettier on other files that Biome doesn't support
    prettier = {
      enable = true;
      files = "\.(md|html|yml|yaml|json)$";
    };
  };
}
