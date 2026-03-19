# Headless home-manager module: cross-platform, no GUI, no personal identity.
# Import this on any remote server for a batteries-included terminal environment.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./options.nix ];

  home.packages =
    with pkgs;
    [
      eza
      git
      htop
      ripgrep
      ast-grep
      tmux
      unzip
      wget
      silver-searcher

      # nix tools
      nixd
      nixfmt
      nil
      cachix

      # formatters
      shfmt
      pgformatter

      # infra
      opentofu

      # JS tools
      nodejs_24
      (yarn.override { nodejs = nodejs_24; })
      (nodePackages.pnpm.override { nodejs = nodejs_24; })
      bun
      oxfmt
      oxlint

      # python
      python3

      findutils
      coreutils-full
      zsh
      gnugrep

      # Rust
      rustup
      openssl
      cargo-workspaces

      # language servers
      basedpyright
      typescript-language-server
      svelte-language-server

      mosh
      imagemagick
      chafa

      # PDF tools
      poppler-utils
      pdfgrep
      qpdf
      ghostscript
      mupdf

      yj
      devenv
      pypi2nix
      lice

      # from additional-nix-packages overlay
      additional-nix-packages.biome
      additional-nix-packages.gogcli
      additional-nix-packages.linear-cli
      additional-nix-packages.lintel
      additional-nix-packages.wacli
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin [
      additional-nix-packages.notifykit
    ]);

  home.stateVersion = "22.05";

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
        is-merged = ''!f() { commit=''${1:-HEAD}; for branch in origin/master origin/main master main; do if git merge-base --is-ancestor "$commit" "$branch" 2>/dev/null; then echo "✓ Commit is merged into $branch"; return 0; fi; done; echo "✗ Commit is not merged into any main branch"; return 1; }; f'';
      };

      core.excludesFile = "${./static/gitignore_global}";
      push.default = "simple";
      init.defaultBranch = "master";
    };

    lfs.enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.difftastic.enable = true;

  programs.go.enable = true;
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      lualine-nvim
      nvim-web-devicons
      telescope-nvim
      plenary-nvim
      smart-open-nvim
      sqlite-lua
      (nvim-treesitter.withPlugins (
        p: with p; [
          nix
          lua
          javascript
          typescript
          tsx
          json
          yaml
          toml
          bash
          rust
          go
          python
          markdown
          html
          css
          svelte
        ]
      ))
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      gitsigns-nvim
      nvim-surround
      comment-nvim
      nvim-autopairs
      indent-blankline-nvim
      which-key-nvim
      neo-tree-nvim
      nui-nvim
      tiny-inline-diagnostic-nvim
      conform-nvim
      vim-sleuth
      bullets-vim
    ];
    initLua = builtins.readFile ./static/nvim-init.lua;
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "nord";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        lsp.display-messages = true;
        file-picker.hidden = false;
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
      ];
    };
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

  programs.fd = {
    enable = true;
    hidden = true;
    extraOptions = [ "--follow" ];
    ignores = [
      ".git/"
      "node_modules/"
    ];
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = false;
    fileWidgetCommand = "fd --type f --type d --type l";
    changeDirWidgetCommand = "fd --type d";
  };

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
      # skim: source key-bindings for ctrl-t and alt-c, but not via enableZshIntegration
      # so that atuin keeps ctrl-r precedence (last binding wins)
      source "${pkgs.skim}/share/skim/key-bindings.zsh"
      bindkey '^I' expand-or-complete
      bindkey '^R' _atuin_search_widget

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^[[1;3C' forward-word
        bindkey '^[[1;3D' backward-word
      ''}

      ${builtins.readFile ./static/shell-utils.zsh};
      source $HOME/dotfiles-private/helpers.zsh
    '';

    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
      DOTFILES = "${config.home.homeDirectory}/dotfiles";
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

      vi = "nvim";
      unescape = "jq -r .";

      zed = "zeditor";
      localip = "ifconfig | grep -Eo 'inet (addr:)?([0-9]*.){3}[0-9]*' | grep -Eo '([0-9]*.){3}[0-9]*' | grep -v '127.0.0.1'";
      funky = "sfxl fortnite";

      # Claude Code
      claude-install = "curl -fsSL https://claude.ai/install.sh | bash";
    }
    // lib.listToAttrs (
      builtins.genList (
        i:
        let
          n = i + 2;
        in
        lib.nameValuePair "claude-${toString n}" "CLAUDE_CONFIG_DIR=~/.claude-${toString n} claude"
      ) (config.igm.claudeInstances - 1)
    );

    history = {
      size = 500000;
      save = 500000;
      share = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "autocd"
      "cdspell"
      "dotglob"
      "expand_aliases"
      "interactive_comments"
    ];

    historySize = 500000;
    historyFileSize = 500000;
    historyControl = [
      "ignoredups"
      "ignorespace"
      "erasedups"
    ];

    shellAliases = {
      gac = "git ac";
      gj = "cd $(git root)";
      gd = "git dft";
      gs = "git status";

      ls = "${pkgs.eza}/bin/eza";
      l = "${pkgs.eza}/bin/eza -lah";

      x = "exit";
      c = "clear";
    };
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    variables = {
      show-all-if-ambiguous = true;
      completion-ignore-case = true;
      completion-map-case = true;
      colored-stats = true;
      mark-directories = true;
      mark-symlinked-directories = true;
      bell-style = "none";
      colored-completion-prefix = true;
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
      enableBashIntegration = true;
    };

    bat = {
      enable = true;
      config = {
        map-syntax = [ "*.alloy:Terraform" ];
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };

    jq.enable = true;

    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        dialect = "us";
        style = "compact";
        inline_height = 20;
        show_preview = true;
        history_filter = [
          "^secret"
          "^export.*TOKEN"
          "^export.*KEY"
          "^export.*PASSWORD"
        ];
      };
    };
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
        continuum
      ];
    extraConfig = ''
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      set-option -g default-command "${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l ${pkgs.zsh}/bin/zsh"
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
}
