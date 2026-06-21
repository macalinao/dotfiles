{ ... }:
{
  partitions.dev = {
    extraInputsFlake = ../dev;
    module =
      { inputs, ... }:
      {
        imports = [
          inputs.git-hooks-nix.flakeModule
          inputs.treefmt-nix.flakeModule
          ./dev-shells.nix
        ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };

            treefmt = {
              programs.nixfmt.enable = true;
              programs.shfmt = {
                enable = true;
                indent_size = 2;
              };
              programs.stylua.enable = true;
              programs.kdlfmt.enable = true;
              # Oxc formatter (oxfmt) handles the full web/data set via its
              # default includes: JS/TS/JSX/TSX, JSON/JSONC/JSON5, CSS/SCSS,
              # HTML, Markdown/MDX, YAML, GraphQL, Vue. Replaces dprint entirely.
              programs.oxfmt.enable = true;
            };

            pre-commit.check.enable = false;
            pre-commit.settings.hooks.treefmt.enable = true;

            devShells.default = pkgs.mkShell {
              shellHook = config.pre-commit.installationScript;
              packages = with pkgs; [
                git
                coreutils-full
              ];
            };
          };
      };
  };
}
