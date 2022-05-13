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

  full-system-update = with pkgs;
    let
      flakePath =
        if stdenv.isLinux then
          "./private/flakes/nixos"
        else if stdenv.isDarwin then
          "./private/flakes/darwin"
        else
          null;
    in
    writeScriptBin "full-system-update" ''
      #!${bash}/bin/bash
      set -x

      ${lib.optionalString (flakePath == null) ''
        echo "No system flake found for this platform."
        exit 1
      ''}

      echo "Updating private dotfiles."
      cd $HOME/dotfiles-private && git add -A . && git commit -m "Updates" && git frp

      cd $HOME/dotfiles

      echo "Updating igm and dotfiles-private-raw flakes."
      nix flake lock --update-input igm --update-input dotfiles-private-raw ${flakePath}

      ${lib.optionalString stdenv.isLinux ''
        sudo nixos-rebuild switch --impure --flake "./private/flakes/nixos#primary"
      ''}

      ${lib.optionalString stdenv.isDarwin ''
        ${let
          darwinConfiguration =
            if stdenv.isAarch64 then "ian-mbp-m1" else "ian-mbp";
        in ''
          nix build "./private/flakes/darwin#darwinConfigurations.${darwinConfiguration}.system" --show-trace || exit 1
          ./result/sw/bin/darwin-rebuild switch --flake "./private/flakes/darwin#${darwinConfiguration}"
          rm -r result
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
