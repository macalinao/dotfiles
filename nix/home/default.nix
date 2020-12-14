{ config, pkgs, lib, ... }:

{
  imports = [ ./os-specific.nix ./programs/vscode.nix ./dotfiles ];

  nixpkgs = import ./nixpkgs-config.nix;

  home.packages = with pkgs; [
    exa
    git
    gitAndTools.hub
    htop
    silver-searcher
    tmux
    unzip
    wget
    whois

    # Editors
    vim

    findutils
    coreutils-full

    cmatrix
    zsh
    gnugrep
    rustup

    keybase
  ];

  programs.go = { enable = true; };

  programs.home-manager = { enable = true; };

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    initExtra = ". $HOME/dotfiles/lib/zshrc";
    envExtra = ''
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ];
      then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi
      export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels:$NIX_PATH
      . /etc/static/zshrc
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';
  };

  programs.z-lua = { enable = true; };
  programs.skim = { enable = true; };

  programs.jq = { enable = true; };

  programs.kitty = { enable = true; };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs;
      with tmuxPlugins; [
        cpu
        nord
        tmux-fzf
        yank
        resurrect
        continuum
      ];

    extraConfig = ''
      bind c new-window      -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
    '';
  };
}
