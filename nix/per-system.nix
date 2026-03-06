{ ... }:
{
  perSystem =
    { config, pkgs, ... }:
    {
      packages = import ./shells { inherit pkgs; };

      treefmt = {
        programs.nixfmt.enable = true;
        programs.shfmt = {
          enable = true;
          indent_size = 2;
        };
        programs.stylua.enable = true;
        programs.dprint = {
          enable = true;
          includes = [
            "*.md"
            "*.json"
            "*.yml"
            "*.yaml"
            "*.html"
          ];
          settings.plugins = pkgs.dprint-plugins.getPluginList (
            plugins: with plugins; [
              dprint-plugin-json
              dprint-plugin-markdown
              g-plane-pretty_yaml
              g-plane-markup_fmt
            ]
          );
        };
      };

      pre-commit.check.enable = false;
      pre-commit.settings.hooks.treefmt.enable = true;

      devShells.default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs; [
          git
          coreutils-full
          dprint
        ];
      };
    };
}
