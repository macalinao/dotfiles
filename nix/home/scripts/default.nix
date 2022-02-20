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

  full-system-update = pkgs.writeScriptBin "full-system-update" ''
    #!${pkgs.bash}/bin/bash
    set -x

    echo "Updating private dotfiles."
    cd $HOME/dotfiles-private && git add -A . && git commit -m "Updates" && git frp

    cd $HOME/dotfiles

    ${pkgs.lib.optionalString pkgs.stdenv.isLinux ''
      sudo nixos-rebuild switch --flake "./private/flakes/nixos#primary"
    ''}

    ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      ${if pkgs.stdenv.isAarch64 then ''
        nix build "./private/flakes/darwin#darwinConfigurations.ian-mbp-m1.system"
        ./result/sw/bin/darwin-rebuild switch --flake "./#ian-mbp-m1"
      '' else ''
        nix build "./private/flakes/darwin#darwinConfigurations.ian-mbp.system"
        ./result/sw/bin/darwin-rebuild switch --flake "./#ian-mbp"
      ''}
    ''}
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
