_: pkgs: {
  nxs = pkgs.writeScriptBin "nxs" ''
    #!${pkgs.zsh}/bin/zsh

    if [ -e $DOTFILES/nix/shells/$1/default.nix ]; then
      SHELL_PATH=$DOTFILES/nix/shells/$1/default.nix
    else
      SHELL_PATH=$DOTFILES/nix/shells/$1.nix
    fi
    if [ ! -e $SHELL_PATH ]; then
      echo "Shell does not exist."
      exit 1
    fi
    ${pkgs.nix}/bin/nix-shell --command ${pkgs.zsh}/bin/zsh --arg pkgs $DOTFILES/nix/nixpkgs $SHELL_PATH
  '';

  full-system-update = pkgs.writeScriptBin "full-system-update" ''
    #!${pkgs.zsh}/bin/zsh
    set -x

    # update nix channels
    nix-channel --update

    # update dotfiles
    cd ~/dotfiles-private && git add -A . && git commit -m "Updates" && git frp

    if which darwin-rebuild; then
      darwin-rebuild switch
    fi

    if which nixos-rebuild; then
      nixos-rebuild switch
    fi
  '';
}
