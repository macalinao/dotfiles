{ dotfiles-private, lib, pkgs }:

{
  programs.git.includes = lib.flatten (lib.mapAttrsToList
    (profile:
      { name ? null
      , signingKey ? null
      , email ? "${profile}-github@igm.pub"
      , gitConfig ? null
      , additionalGitignore ? null
      , additionalPrefixes ? [ ]
      , ...
      }@profileInfo:
      let
        github = ({ github = { }; } // profileInfo).github // {
          username = "macalinao";
          organization = profile;
        };
        prefixes = [ "~/proj/${github.organization}/" ] ++ additionalPrefixes;
        excludesFile = pkgs.writeTextFile {
          name = "gitignore_global";
          text = ''
            # Additional config for profile ${profile}
            ${additionalGitignore}'';
        };
      in
      map
        (prefix: {
          contents = lib.mkMerge [
            gitConfig
            {
              user = lib.mkMerge [{
                inherit email;
              }
                (lib.mkIf (signingKey != null) { inherit signingKey; })
                (lib.mkIf (name != null) { inherit name; })];
            }
            (lib.mkIf (additionalGitignore != null) {
              core.excludesFile = "${excludesFile}";
            })
          ];
          condition = "gitdir/i:${prefix}";
        })
        prefixes)
    dotfiles-private.profiles);

  home.file = dotfiles-private.homeFiles;
  xdg.configFile = dotfiles-private.xdgFiles;
}
