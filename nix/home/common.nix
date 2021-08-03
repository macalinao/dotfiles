{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    exa
    git
    htop
    silver-searcher
    tmux
    unzip
    wget
    whois

    # Editors
    vim

    # for xmonad
    haskell-language-server
    cabal-install
    stack
    ghc

    # JS tools
    nodejs
    yarn
    python

    docker-compose

    findutils
    coreutils-full

    cmatrix
    zsh
    gnugrep
    rustup
    shfmt

    keybase

    niv
    nixfmt
    pypi2nix
    cachix

    imagemagick

    nxs
    full-system-update
    yq

    # formatting
    shfmt

    # wally
    wally-cli
  ];

  programs.vscode = { enable = true; };
  programs.git = {
    enable = true;
    aliases = {
      amend = "commit -a --amend -C HEAD";
      co = "checkout";
      ff = "merge --ff-only";
      ffo = "!git ffr origin";
      ffr =
        "!ffr() { git fetch $1 && git ff $1/$(git which-branch) && git suir; }; ffr";
      frp = "!git ffo && git rom && git poh";
      master = "checkout origin/master -B master";
      poh = "push origin HEAD";
      pohm = "push origin HEAD:master";
      rh = "reset --hard";
      rom = "rebase origin/master";
      root = "rev-parse --show-toplevel";
      sha = "rev-parse HEAD";
      suir = "submodule update --init --recursive";
      which-branch = ''
        !wb() { b="$(git symbolic-ref HEAD)" && echo ''${b#refs/heads/}; }; wb'';
    };
    extraConfig = {
      core.excludesFile = "${./static/gitignore_global}";
      push.default = "simple";
    };
    delta.enable = true;
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "5A246DACA92D4485";
    };
    userName = "Ian Macalinao";
    userEmail = "github@igm.pub";
  };

  programs.go = { enable = true; };

  programs.home-manager = { enable = true; };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "yarn" "gitignore" ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [ "osx" ]);
    };
    initExtra = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^[[1;3C' forward-word
        bindkey '^[[1;3D' backward-word
      ''}
      ${builtins.readFile ./static/shell-utils.zsh};
      source $HOME/dotfiles-private/helpers.zsh
    '';
    envExtra = ''
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ];
      then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi
      if [ -e /etc/static/zshrc ];
      then
        . /etc/static/zshrc
      fi
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      export PATH="$HOME/.cargo/bin:$PATH"
      ${
      # Solana path on Darwin
      lib.optionalString pkgs.stdenv.isDarwin ''
        export PATH="/Users/igm/.local/share/solana/install/active_release/bin:$PATH"
      ''}

      setopt appendhistory
      setopt INC_APPEND_HISTORY  
    '';

    sessionVariables = {
      DOTFILES = "${config.home.homeDirectory}/dotfiles";
      EDITOR = "${pkgs.vim}/bin/vim";
    };

    shellAliases = {
      gac = "git add -A $(git root) && git commit -m";
      gj = "cd $(git root)";
      gd = "git diff";
      gs = "gst";

      ls = "exa";
      l = "exa -lah";

      x = "exit";
      c = "clear";

      vi = "vim";
      bear = "keybase chat send bearcott";
      dylan = "keybase chat send dylanmacalinao";
      unescape = "jq -r .";
      localip =
        "ifconfig | grep -Eo 'inet (addr:)?([0-9]*.){3}[0-9]*' | grep -Eo '([0-9]*.){3}[0-9]*' | grep -v '127.0.0.1'";
      funky = "sfxl fortnite";
    };

    history = {
      size = 500000;
      save = 500000;
      share = true;
    };
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

  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
  };
}
