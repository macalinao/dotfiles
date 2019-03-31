{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";
  private-secrets = "${config.home.homeDirectory}/private_secrets";

  spacemacs = builtins.fetchGit {
    name = "spacemacs";
    url = "git://github.com/syl20bnr/spacemacs";
    ref = "develop";
    rev = "4b195ddfc9228256361e0b264fe974aa86ed51a8";
  };
in {
  home.file.".gitconfig".source = "${dotfiles}/gitconfig";
  home.file.".spacemacs".source = "${dotfiles}/spacemacs";

  home.file.".vimrc".source = "${dotfiles}/vimrc";
  home.file.".vim" = {
    source = "${dotfiles}/vim";
    recursive = true;
  };

  home.file.".emacs.d" = {
    source = spacemacs;
    recursive = true;
  };

  home.file.".sbt" = {
    source = "${dotfiles}/sbt";
    recursive = true;
  };

  home.file.".sbt/1.0/sonatype.sbt".source = "${private-secrets}/dotfiles/sonatype.sbt";

  home.file.".aws" = {
    source = "${private-secrets}/dotfiles/aws";
    recursive = true;
  };

  home.file.".kube" = {
    source = "${private-secrets}/dotfiles/kube";
    recursive = true;
  };

  home.file.".jx" = {
    source = "${private-secrets}/dotfiles/jx";
    recursive = true;
  };

  home.file.".npmrc".source =  "${private-secrets}/dotfiles/npmrc";

  home.file.".tmux.conf" = {
    source = if (pkgs.stdenv.isDarwin) then
      "${dotfiles}/tmux/tmux_mac.conf"
    else
      "${dotfiles}/tmux/linux.conf";
  };
}
