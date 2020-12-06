{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles/dotfiles";

  spacemacs = pkgs.fetchFromGitHub {
    owner = "syl20bnr";
    repo = "spacemacs";
    rev = "4b195ddfc9228256361e0b264fe974aa86ed51a8";
    sha256 = "123mc3hb13kq812l4nv2c7qbasqadyjj3nyhj5y8psg5lqdrl6qx";
  };
in {
  home.file.".gitconfig".source = "${dotfiles}/gitconfig";
  home.file.".spacemacs".source = "${dotfiles}/spacemacs";

  home.file.".vimrc".source = "${dotfiles}/vimrc";
  home.file.".yabairc".source = "${dotfiles}/yabairc";

  home.file.".emacs.d" = {
    source = spacemacs;
    recursive = true;
  };

  home.file.".sbt" = {
    source = "${dotfiles}/sbt";
    recursive = true;
  };

  home.file.".sbt/1.0/linux.sbt".source = "${dotfiles}/sbt/1.0/global.sbt"
    + (if (!pkgs.stdenv.isDarwin) then ".linux" else "");

  home.file.".xscreensaver".source = "${dotfiles}/xscreensaver";

  home.file.".config/fcitx" = {
    source = "${dotfiles}/fcitx";
    recursive = true;
  };

  home.file.".hyper.js".source = "${dotfiles}/hyper.js";
  home.file.".hyper_plugins" = {
    source = "${dotfiles}/hyper_plugins";
    recursive = true;
  };

  home.file.".config/taffybar" = {
    source = "${dotfiles}/taffybar";
    recursive = true;
  };
}
