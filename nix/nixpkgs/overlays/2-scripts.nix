_: pkgs: {
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

    ${pkgs.lib.optionalString pkgs.stdenv.isLinux ''
      cd $HOME/dotfiles/private/flakes/nixos
      sudo nixos-rebuild switch --flake ".#primary"
    ''}

    ${pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
      cd $HOME/dotfiles/private/flakes/darwin
      if [[ $(uname -m) = "arm64" ]]; then
        nix build "./#darwinConfigurations.ian-mbp-m1.system"
        ./result/sw/bin/darwin-rebuild switch --flake "./#ian-mbp-m1"
      else
        nix build "./#darwinConfigurations.ian-mbp.system"
        ./result/sw/bin/darwin-rebuild switch --flake "./#ian-mbp"
      fi
    ''}
  '';

  configure-monitors = pkgs.writeShellScriptBin "configure-monitors" ''
    configure_monitors() {
      ${pkgs.xorg.xrandr}/bin/xrandr \
        --output DVI-D-0 --off \
        --output HDMI-0 --mode 3840x2160 --pos 3840x0 --rotate normal \
        --output HDMI-1 --mode 2560x1440 --pos 2161x2160 --rotate normal --rate 143.91 \
        --output DP-0 --mode 2560x1440 --pos 4721x2160 --rotate normal --rate 165.08 \
        --output DP-1 --off \
        --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal \
        --output DP-3 --off \
        --output DP-2-3 --mode 3840x2160 --pos 7281x2160 --rotate normal \
        --output HDMI-2-2 --off \
        --output HDMI-2-3 --off \
        --output DP-2-4 --off \
        --output HDMI-2-4 --off
    }

    configure_monitors
  '';
}
