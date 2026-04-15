{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.igm.asimeow;
  yamlFormat = pkgs.formats.yaml { };
in
{
  options.igm.asimeow = {
    enable = lib.mkEnableOption "asimeow Time Machine exclusion manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.additional-nix-packages.asimeow;
      defaultText = lib.literalExpression "pkgs.additional-nix-packages.asimeow";
      description = "asimeow package to use.";
    };

    intervalSeconds = lib.mkOption {
      type = lib.types.int;
      default = 6 * 60 * 60;
      description = "How often the launchd agent runs asimeow (seconds). Default: every 6 hours.";
    };

    roots = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "~/proj/" ];
      example = [
        "~/proj/"
        "~/work/"
      ];
      description = "Directories asimeow scans recursively for sentinel files.";
    };

    ignore = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ".git" ];
      description = "Directory names skipped during exploration.";
    };

    rules = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Rule name.";
            };
            file_match = lib.mkOption {
              type = lib.types.str;
              description = "Glob for sentinel files that trigger the rule.";
            };
            exclusions = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Sibling directory names to exclude from Time Machine.";
            };
          };
        }
      );
      default = [
        {
          name = "node";
          file_match = "package.json";
          exclusions = [
            "node_modules"
            "dist"
            "build"
            ".next"
            ".turbo"
            ".parcel-cache"
            ".cache"
          ];
        }
        {
          name = "rust";
          file_match = "Cargo.toml";
          exclusions = [ "target" ];
        }
        {
          name = "python";
          file_match = "requirements.txt";
          exclusions = [
            "venv"
            ".venv"
            "__pycache__"
            ".pytest_cache"
          ];
        }
        {
          name = "python-pyproject";
          file_match = "pyproject.toml";
          exclusions = [
            ".venv"
            "venv"
            "__pycache__"
            ".pytest_cache"
            ".mypy_cache"
            ".ruff_cache"
          ];
        }
        {
          name = "go";
          file_match = "go.mod";
          exclusions = [ "vendor" ];
        }
        {
          name = "gradle";
          file_match = "build.gradle";
          exclusions = [
            ".gradle"
            "build"
          ];
        }
        {
          name = "gradle-kts";
          file_match = "build.gradle.kts";
          exclusions = [
            ".gradle"
            "build"
          ];
        }
        {
          name = "swift";
          file_match = "Package.swift";
          exclusions = [
            ".build"
            ".swiftpm"
          ];
        }
        {
          name = "cocoapods";
          file_match = "Podfile";
          exclusions = [ "Pods" ];
        }
        {
          name = "xcode";
          file_match = "*.xcodeproj";
          exclusions = [
            "DerivedData"
            "build"
          ];
        }
        {
          name = "anchor";
          file_match = "Anchor.toml";
          exclusions = [
            "target"
            ".anchor"
            "test-ledger"
          ];
        }
        {
          name = "devenv";
          file_match = "devenv.nix";
          exclusions = [ ".devenv" ];
        }
        {
          name = "direnv";
          file_match = ".envrc";
          exclusions = [ ".direnv" ];
        }
        {
          name = "dotnet";
          file_match = "*.csproj";
          exclusions = [
            "obj"
            "bin"
            "packages"
          ];
        }
        {
          name = "terraform";
          file_match = "main.tf";
          exclusions = [ ".terraform" ];
        }
        {
          name = "bazel";
          file_match = "WORKSPACE";
          exclusions = [
            "bazel-out"
            "bazel-bin"
            "bazel-testlogs"
          ];
        }
        {
          name = "elixir";
          file_match = "mix.exs";
          exclusions = [
            "_build"
            "deps"
          ];
        }
      ];
      description = "File-match rules mapping sentinel files to sibling directories to exclude.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "igm.asimeow is only supported on macOS.";
      }
    ];

    home.packages = [ cfg.package ];

    xdg.configFile."asimeow/config.yaml".source = yamlFormat.generate "asimeow-config.yaml" {
      roots = map (path: { inherit path; }) cfg.roots;
      inherit (cfg) ignore rules;
    };

    launchd.agents.asimeow = {
      enable = true;
      config = {
        ProgramArguments = [ "${cfg.package}/bin/asimeow" ];
        StartInterval = cfg.intervalSeconds;
        RunAtLoad = true;
        StandardOutPath = "${config.home.homeDirectory}/Library/Logs/asimeow.log";
        StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/asimeow.log";
      };
    };
  };
}
