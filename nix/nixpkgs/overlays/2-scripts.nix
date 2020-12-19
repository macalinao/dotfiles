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

  configure-monitors = pkgs.writeShellScriptBin "configure-monitors" ''
    configure_monitors() {
      ${pkgs.xrandr}/bin/xrandr --output DVI-D-0 --off \
        --output HDMI-0 --mode 3840x2160 --pos 3840x0 --rotate normal \
        --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal \
        --output DP-0 --mode 2560x1440 --pos 7108x2160 --rotate normal \
        --output DP-1 --off \
        --output DP-2 --mode 2560x1440 --pos 1988x2160 --rotate normal --rate 165.08 \
        --output DP-3 --off \
        --output DP-1-1 --mode 2560x1440 --pos 4548x2160 --rotate normal --rate 165.08 \
        --output HDMI-1-1 --off \
        --output HDMI-1-2 --off \
        --output DP-1-2 --off \
        --output HDMI-1-3 --off
    }

    configure_monitors

    # set a monitor small
    ${pkgs.xrandr}/bin/xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal --output HDMI-1 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-0 --mode 2560x1440 --pos 7108x2160 --rotate normal --output DP-1 --off --output DP-2 --mode 2560x1440 --pos 1988x2160 --rotate normal --output DP-3 --off --output DP-1-1 --mode 2560x1440 --pos 4548x2160 --rotate normal --output HDMI-1-1 --off --output HDMI-1-2 --off --output DP-1-2 --off --output HDMI-1-3 --off

    configure_monitors
  '';
}
