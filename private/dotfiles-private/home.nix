{ dotfiles-private, lib, pkgs }:

{
  programs.git.includes = lib.mapAttrsToList (profile: profileInfo: {
    path = "${pkgs.writeTextFile {
      name = "config";
      text = ''
        [user]
          email = "${profileInfo.email}"
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
    condition = "gitdir/i:~/proj/${profileInfo.githubOrganization}/";
  }) dotfiles-private.profiles;

  home.file = dotfiles-private.homeFiles;
  xdg.configFile = dotfiles-private.xdgFiles;
}
