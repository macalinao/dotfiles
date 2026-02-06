{
  config,
  pkgs,
  lib,
  systemConfig,
  ...
}:

{
  home.packages = with pkgs; [
    eza
    git
    htop
    silver-searcher
    ripgrep
    ast-grep
    tmux
    unzip
    wget
    # whois

    # nix language server
    rnix-lsp

    # JS tools
    nodejs_24
    (yarn.override {
      nodejs = nodejs_24;
    })
    (nodePackages.pnpm.override {
      nodejs = nodejs_24;
    })
    bun
    # python

    python3
    # poetry

    # docker-compose

    findutils
    coreutils-full

    cmatrix
    zsh
    gnugrep

    # Rust tools
    rustup
    # cargo
    # rustc
    openssl
    # rust-analyzer

    shfmt
    cargo-workspaces
    # cargo-outdated

    nixfmt
    pypi2nix
    cachix
    nil

    imagemagick

    # yq
    yj # toml CLI

    lice

    # formatting
    shfmt

    stockfish
    # Wrangler is no longer available on Darwin
    # wrangler
    android-tools

    # jdk23
    proxmark3
    devenv

    linear-cli
  ];

  home.stateVersion = "22.05";

  programs.vscode = {
    enable = true;

    # WARNING: this is impure, so we only do this on Linux
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      pkgs.lib.optionals (pkgs.stdenv.isLinux && !systemConfig.igm.pure) [ matklad.rust-analyzer ];
  };

  programs.git = {
    enable = true;
    settings = {
      alias = {
        amend = "commit -a --amend -C HEAD";
        ac = "!git add -A $(git root) && git c -a -m";
        c = "commit";
        co = "checkout";
        ff = "merge --ff-only";
        ffo = "!git ffr origin";
        ffr = "!ffr() { git fetch $1 && git ff $1/$(git which-branch) && git suir; }; ffr";
        frp = "!git ffo && git rom && git poh";
        master = "checkout origin/master -B master";
        poh = "push origin HEAD";
        pohm = "push origin HEAD:master";
        rh = "reset --hard";
        rom = "rebase origin/master";
        root = "rev-parse --show-toplevel";
        sha = "rev-parse HEAD";
        suir = "submodule update --init --recursive";
        which-branch = ''!wb() { b="$(git symbolic-ref HEAD)" && echo ''${b#refs/heads/}; }; wb'';
        # Difftastic aliases
        dft = "-c diff.external=${pkgs.difftastic}/bin/difft diff";
        dl = "-c diff.external=${pkgs.difftastic}/bin/difft log -p --ext-diff";
        ds = "-c diff.external=${pkgs.difftastic}/bin/difft show --ext-diff";
      };
      user = {
        name = "Ian Macalinao";
        email = "github@igm.pub";
      };

      core.excludesFile = "${./static/gitignore_global}";
      push.default = "simple";
      init.defaultBranch = "master";
    };

    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "5A246DACA92D4485";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.difftastic.enable = true;

  programs.go = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Browser password management
  programs.browserpass.enable = true;
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline ];
    settings = {
      tabstop = 2;
      ignorecase = true;
      shiftwidth = 2;
      expandtab = true;
    };
    extraConfig = builtins.readFile ./static/vimrc;
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.npm-packages/bin"
    "${config.home.homeDirectory}/.cache/.bun/bin"
    "${config.home.homeDirectory}/.cargo/bin"
    "${config.home.homeDirectory}/dotfiles/scripts"
  ]
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    "/opt/homebrew/bin"
    "${config.home.homeDirectory}/.local/share/solana/install/active_release/bin"
  ]);

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    oh-my-zsh = {
      enable = true;
      theme = "arrow";
      plugins = [
        "git"
        "yarn"
        "gitignore"
      ]
      ++ (lib.optionals pkgs.stdenv.isDarwin [ "macos" ]);
    };
    initContent = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^[[1;3C' forward-word
        bindkey '^[[1;3D' backward-word
      ''}
      ${builtins.readFile ./static/shell-utils.zsh};
      source $HOME/dotfiles-private/helpers.zsh
    '';

    sessionVariables = {
      DOTFILES = "${config.home.homeDirectory}/dotfiles";
      EDITOR = "${pkgs.vim}/bin/vim";
      # If your computer is in a different language, the terminal may break without this line
      LC_ALL = "en_US.UTF-8";
    };

    shellAliases = {
      gac = "git ac";
      gj = "cd $(git root)";
      gd = "git dft";
      gs = "gst";

      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -lah";

      x = "exit";
      c = "clear";
      nf = "nixfmt **/*.nix";

      vi = "vim";
      bear = "keybase chat send bearcott";
      dylan = "keybase chat send dylanmacalinao";
      unescape = "jq -r .";
      localip = "ifconfig | grep -Eo 'inet (addr:)?([0-9]*.){3}[0-9]*' | grep -Eo '([0-9]*.){3}[0-9]*' | grep -v '127.0.0.1'";
      funky = "sfxl fortnite";
      ysetup = "yarn set version canary";
      ysdk = "yarn dlx @yarnpkg/sdks vscode";

      # Claude Code
      claude-2 = "CLAUDE_CONFIG_DIR=~/.claude-2 claude";
      claude-3 = "CLAUDE_CONFIG_DIR=~/.claude-3 claude";
      claude-install = "curl -fsSL https://claude.ai/install.sh | bash";
    };

    history = {
      size = 500000;
      save = 500000;
      share = true;
    };
  };

  programs = {
    zellij = {
      enable = true;
      settings = {
        theme = "nord";
        default-mode = "locked";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
    skim.enable = true;
    jq.enable = true;
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins =
      with pkgs;
      with tmuxPlugins;
      [
        cpu
        nord
        tmux-fzf
        yank
        # resurrect
        continuum
      ];
    extraConfig = ''
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"
      ''}
    '';
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        setEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };

  nix = {
    enable = true;
    # package = pkgs.nixUnstable;
    registry = {
      move = {
        from = {
          id = "move";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "movingco";
          repo = "move.nix";
        };
      };
      igm = {
        from = {
          id = "igm";
          type = "indirect";
        };
        to = {
          path = "${config.home.homeDirectory}/dotfiles/nix";
          type = "path";
        };
      };
    };
  };
}
