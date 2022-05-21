{ pkgs }: {
  nxs = pkgs.writeShellScriptBin "nxs" ''
    if [ -e $DOTFILES/nix/shells/$1/default.nix ]; then
      SHELL_PATH=$DOTFILES/nix/shells/$1/default.nix
    else
      SHELL_PATH=$DOTFILES/nix/shells/$1.nix
    fi
    if [ ! -e $SHELL_PATH ]; then
      echo "Shell does not exist."
      exit 1
    fi
    export SHELL=${pkgs.zsh}/bin/zsh
    ${pkgs.nix}/bin/nix-shell --command ${pkgs.zsh}/bin/zsh --arg pkgs $DOTFILES/nix/nixpkgs $SHELL_PATH
  '';

  cachix-build-and-push = pkgs.writeScriptBin "cachix-build-and-push" ''
    #!${pkgs.bash}/bin/bash
    set -x

    CACHIX_CACHE="''${2:-igm}"
    echo "Building $1 and pushing to $CACHIX_CACHE"

    nix -Lv build $1 --json \
      | jq -r '.[].outputs | to_entries[].value' \
      | cachix push $CACHIX_CACHE
  '';

}
