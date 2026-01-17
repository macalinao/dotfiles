{
  config,
  dotfiles-private,
  lib,
  pkgs,
}:

let
  # Process all profiles to extract git includes and envrc files
  processedProfiles = lib.mapAttrsToList (
    profile:
    {
      name ? null,
      signingKey ? null,
      email ? "${profile}-github@igm.pub",
      gitConfig ? null,
      additionalGitignore ? null,
      extraDirectories ? [ ],
      ...
    }@profileInfo:
    let
      github = ({ github = { }; } // profileInfo).github // {
        username = "macalinao";
        organization = profile;
      };
      hasGithubConfig = profileInfo ? github;
      directories = [ github.organization ] ++ extraDirectories;
      prefixes = map (dir: "~/proj/${dir}/") directories;
      excludesFile = pkgs.writeTextFile {
        name = "gitignore_global";
        text = ''
          # Additional config for profile ${profile}
          ${additionalGitignore}'';
      };
      gitIncludes = map (prefix: {
        contents = lib.mkMerge [
          gitConfig
          {
            user = lib.mkMerge [
              {
                inherit email;
              }
              (lib.mkIf (signingKey != null) { inherit signingKey; })
              (lib.mkIf (name != null) { inherit name; })
            ];
          }
          (lib.mkIf (additionalGitignore != null) {
            core.excludesFile = "${excludesFile}";
          })
        ];
        condition = "gitdir/i:${prefix}";
      }) prefixes;
      # Generate .envrc files for each directory if github config exists in profile
      envrcFiles = lib.optionalAttrs hasGithubConfig (
        lib.listToAttrs (
          map (dir: {
            name = "proj/${dir}/.envrc";
            value = {
              text = ''
                export GH_CONFIG_DIR="${config.home.homeDirectory}/proj/${github.organization}/.gh"
              '';
            };
          }) directories
        )
      );
    in
    {
      inherit gitIncludes envrcFiles;
    }
  ) dotfiles-private.profiles;

  allGitIncludes = lib.flatten (map (p: p.gitIncludes) processedProfiles);
  allEnvrcFiles = lib.foldl' (acc: p: acc // p.envrcFiles) { } processedProfiles;
in
{
  programs.git.includes = allGitIncludes;

  home.file = dotfiles-private.homeFiles // allEnvrcFiles;
  # xdg.configFile = dotfiles-private.xdgFiles;
}
