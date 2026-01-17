{
  dotfiles-private,
  lib,
  pkgs,
}:

let
  # Process all profiles to extract git includes
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
    in
    {
      inherit gitIncludes;
    }
  ) dotfiles-private.profiles;

  allGitIncludes = lib.flatten (map (p: p.gitIncludes) processedProfiles);
in
{
  programs.git.includes = allGitIncludes;

  home.file = dotfiles-private.homeFiles;
  # xdg.configFile = dotfiles-private.xdgFiles;
}
