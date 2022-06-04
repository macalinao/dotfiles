{ dotfiles-private, lib, pkgs }:

{
  programs.git.includes = lib.flatten (lib.mapAttrsToList
    (profile:
      { github, email, ... }@profileInfo:
      let
        prefixes = [ "~/proj/${github.organization}/" ] ++ profileInfo.additionalPrefixes;
      in
      map
        (prefix: {
          path = "${pkgs.writeTextFile {
      name = "config";
      text = ''
        [user]
        ${lib.optionalString (profileInfo.name != "") "  name = \"${profileInfo.name}\""}"
        ${lib.optionalString (profileInfo.signingKey != "") "  signingkey = \"${profileInfo.signingKey}\""}"
        email = "${email}"
        ${profileInfo.additionalGitConfig}
        ${lib.optionalString (profileInfo.additionalGitignore != "") ''
          [core]
            excludesFile = "${
              pkgs.writeTextFile {
                name = "gitignore_global";
                text = ''
                  # Additional config for profile ${profile}
                  ${profileInfo.additionalGitignore}'';
              }
            }"
        ''}
      '';
    }}";
          condition = "gitdir/i:${prefix}";
        })
        prefixes)
    dotfiles-private.profiles);

  home.file = dotfiles-private.homeFiles;
  xdg.configFile = dotfiles-private.xdgFiles;
}
