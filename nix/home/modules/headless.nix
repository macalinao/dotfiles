# Headless home-manager module: cross-platform, no GUI, no personal identity.
# Import this on any remote server for a batteries-included terminal environment.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ../options.nix
    ../dotfiles.nix
    ../../nix-settings-shared.nix
  ];

  # Aliases shared across all shells.
  home.shellAliases = {
    gac = "git ac";
    gj = "cd $(git root)";
    gd = "git dft";
    gs = "git status";
    gst = "git status";

    ls = "${pkgs.eza}/bin/eza";
    l = "${pkgs.eza}/bin/eza -lah";

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    x = "exit";
    c = "clear";
    nf = "nixfmt **/*.nix";

    vi = "nvim";
    unescape = "jq -r .";

    zed = "zeditor";
    localip = "ifconfig | grep -Eo 'inet (addr:)?([0-9]*.){3}[0-9]*' | grep -Eo '([0-9]*.){3}[0-9]*' | grep -v '127.0.0.1'";
    funky = "sfxl fortnite";
    dotfiles = "cd ${config.igm.dotfilesPath}";

    # Claude Code
    claude-install = "curl -fsSL https://claude.ai/install.sh | bash";

    git-presign = ''gpg --sign --local-user "$(git config user.signingkey)" -o /dev/null </dev/null'';
  };

  home.packages =
    with pkgs;
    [
      (callPackage ../../packages/dotfiles-scripts.nix {
        dotfilesPath = config.igm.dotfilesPath;
      })
      (callPackage ../../packages/git-worktree-runner.nix { })
      eza
      git
      gibo
      btop
      htop
      ripgrep
      ast-grep
      tmux
      unzip
      wget
      silver-searcher
      dnsutils
      lsof

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
      go-task

      # JS tools
      (yarn.override { nodejs = nodejs_24; })
      pnpm
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
      cargo-nextest
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
      lice

      # AI coding tools — pulled directly from their flakes (own pinned nixpkgs +
      # cachix caches), bypassing the default overlay so they don't shadow
      # nixpkgs and don't force rebuilds against this repo's nixpkgs pin.
      inputs.claude-code-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.codex

      # from additional-nix-packages overlay
      additional-nix-packages.biome
      additional-nix-packages.gogcli
      additional-nix-packages.lintel
      additional-nix-packages.wacli
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin [
      additional-nix-packages.notifykit
    ])
    ++ (lib.optionals pkgs.stdenv.isLinux [
      bubblewrap
      socat
      libseccomp
    ]);

  home.stateVersion = "26.05";

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

      push.default = "simple";
      init.defaultBranch = "master";
    };

    ignores = [
      "*.swo"
      "*.swp"
      ".#*"
      ".DS_Store"
      ".bloop/"
      ".direnv/"
      ".ensime"
      ".ensime_cache/"
      ".env"
      ".gradle/"
      ".gradletasknamecache"
      ".idea/"
      ".metals/"
      ".nb-gradle/"
      ".tern-port"
      ".tmp"
      "dump.rdb"
      "main.iml"
      "npm-debug.log"
      "~$*"
      "**/.claude/settings.local.json"
      ".claude/scheduled_tasks.lock"
      ".codex"
      "!.codex/"
    ];

    lfs.enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.difftastic.enable = true;

  programs.bun.enable = true;
  programs.cargo = {
    enable = true;
    package = null;
  };
  programs.go.enable = true;
  programs.home-manager.enable = true;
  programs.npm = {
    enable = true;
    package = pkgs.nodejs_24;
    settings = {
      prefix = "\${HOME}/.npm";
      scripts-prepend-node-path = "auto";
      "//registry.npmjs.org/:_authToken" = "\${NPM_AUTH_TOKEN}";
      "//npm.pkg.github.com/:_authToken" = "\${NPM_GITHUB_AUTH_TOKEN}";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    # FIXME: Remove once NixOS/nixpkgs#502769 lands in nixpkgs-unstable
    package = pkgs.direnv.overrideAttrs (old: {
      env = (old.env or { }) // {
        CGO_ENABLED = 1;
      };
    });
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
    extraConfig = builtins.readFile ../static/vimrc;
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
    initLua = builtins.readFile ../static/nvim-init.lua;
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
    "${config.home.homeDirectory}/.npm/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ]
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    "/opt/homebrew/bin"
    "${config.home.homeDirectory}/.local/share/solana/install/active_release/bin"
  ]);

  home.sessionVariables = lib.mkIf config.igm.disableSwitch {
    IGM_SWITCH_DISABLE = "true";
  };

  # ~/.local/bin is appended (not prepended) so Nix-managed binaries
  # take precedence over anything the user drops there manually.
  programs.zsh.envExtra = ''
    export PATH="$PATH:$HOME/.local/bin"
  '';
  programs.bash.bashrcExtra = lib.mkMerge [
    ''
      export PATH="$PATH:$HOME/.local/bin"

      # git-worktree-runner (gtr) shell integration + completions
      # Sources cached output directly for fast startup (~1ms vs ~60ms).
      if command -v git-gtr >/dev/null 2>&1; then
        _gtr_init="''${XDG_CACHE_HOME:-$HOME/.cache}/gtr/init-gtr.bash"
        [[ -f "$_gtr_init" ]] || eval "$(git gtr init bash)" || true
        source "$_gtr_init" 2>/dev/null || true
        unset _gtr_init
      fi

      # Claude Code runs commands in non-interactive shells, so the direnv
      # hook registered by home-manager never fires. Load it manually and
      # export the current dir's env so tools resolve correctly.
      if command -v direnv >/dev/null 2>&1; then
        if [ -n "$CLAUDECODE" ]; then
          eval "$(direnv hook bash)"
          eval "$(DIRENV_LOG_FORMAT= direnv export bash)"
        fi
      fi
    ''

    # Short-circuit non-interactive shells with a clean status 0. The
    # home-manager-generated guard further down is `[[ $- == *i* ]] ||
    # return` — no explicit status — which returns 1 (from the failed
    # [[ ]]) and kills any caller running under `set -e`. In particular,
    # home-manager's own setup-env wrapper runs `#!bash -el` and sources
    # .profile → .bashrc, so the 1 aborts the activation before the
    # generation is applied. Run last (order 2000, after other modules'
    # mkAfter at 1500) so project env like profile-env still sources for
    # non-interactive Claude Code shells before this guard fires.
    (lib.mkOrder 2000 ''
      [[ $- == *i* ]] || return 0
    '')
  ];

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
    defaultKeymap = "emacs";
    dotDir = "${config.xdg.configHome}/zsh";
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initContent = ''
      # powerlevel10k: source the committed wizard-generated config.
      # Managed declaratively via xdg.configFile below; re-run `p10k configure`
      # and copy the resulting $ZDOTDIR/.p10k.zsh back to config/zsh/p10k.zsh
      # in the dotfiles repo to update.
      source "${config.xdg.configHome}/zsh/.p10k.zsh"

      # skim: source key-bindings for ctrl-t and alt-c, but not via enableZshIntegration
      # so that atuin keeps ctrl-r precedence (last binding wins)
      source "${pkgs.skim}/share/skim/key-bindings.zsh"
      bindkey '^I' expand-or-complete
      bindkey '^R' _atuin_search_widget

      export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate nord)"
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      # All non-alphanumeric characters are word separators (like oh-my-zsh)
      WORDCHARS=

      bindkey '^[[1;3C' forward-word
      bindkey '^[[1;3D' backward-word

      # Alt+Backspace: backward-kill-word
      bindkey '\e^?' backward-kill-word

      # Name zellij tab after initial working directory
      if [[ -n "$ZELLIJ" && "$ZELLIJ" != "0" ]]; then
        command zellij action rename-tab "''${PWD##*/}"
      fi

      ${builtins.readFile ../static/shell-utils.zsh};

      sfxl() {
        ${pkgs.sox}/bin/play -v 10.0 ${
          pkgs.callPackage ../../packages/dotfiles-sfx.nix { }
        }/share/sfx/$1.ogg
      }

      # Shift+Enter (kitty kbd protocol \e[13;2u) accepts the current line
      # so prompts that would otherwise insert a literal newline submit instead.
      bindkey '\e[13;2u' accept-line

      # git-worktree-runner (gtr) shell integration + completions
      # Sources cached output directly for fast startup (~1ms vs ~60ms).
      _gtr_init="''${XDG_CACHE_HOME:-$HOME/.cache}/gtr/init-gtr.zsh"
      [[ -f "$_gtr_init" ]] || eval "$(git gtr init zsh)" || true
      source "$_gtr_init" 2>/dev/null || true
      unset _gtr_init

      # Claude Code runs commands in non-interactive shells, so the direnv
      # hook registered by home-manager never fires. Load it manually and
      # export the current dir's env so tools resolve correctly.
      if command -v direnv >/dev/null 2>&1; then
        if [[ -n "$CLAUDECODE" ]]; then
          eval "$(direnv hook zsh)"
          eval "$(DIRENV_LOG_FORMAT= direnv export zsh)"
        fi
      fi
    '';

    sessionVariables = {
      EDITOR = "nvim";
      LC_ALL = "en_US.UTF-8";
    };

    shellAliases = lib.listToAttrs (
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
        default_mode = "locked";
        keybinds = {
          locked =
            lib.listToAttrs (
              map (n: {
                name = "bind \"Alt ${toString n}\"";
                value = {
                  GoToTab = n;
                };
              }) (lib.range 1 9)
            )
            // {
              # Alt 0 is a "tens" chord prefix: enters tab mode, where the next
              # digit 0..9 jumps to tabs 10..19 and returns to locked.
              "bind \"Alt 0\"" = {
                SwitchToMode = "tab";
              };
              "bind \"Shift Enter\"" = {
                Write = 10;
              };
              "bind \"Ctrl b\"" = {
                SwitchToMode = "tmux";
              };
            };
          "shared_except \"locked\"" =
            lib.listToAttrs (
              map (n: {
                name = "bind \"Alt ${toString n}\"";
                value = {
                  GoToTab = n;
                  SwitchToMode = "locked";
                };
              }) (lib.range 1 9)
            )
            // {
              "bind \"Alt 0\"" = {
                SwitchToMode = "tab";
              };
            };
          tab =
            lib.listToAttrs (
              map (n: {
                name = "bind \"${toString n}\"";
                value = {
                  GoToTab = 10 + n;
                  SwitchToMode = "locked";
                };
              }) (lib.range 0 9)
            )
            // {
              "bind \"Esc\"" = {
                SwitchToMode = "locked";
              };
            };
        };
      };
    };

    # Custom default layout that swaps zellij's built-in tab/status bar for
    # zjstatus, so we can show the local hostname (and mode/session/tabs) in
    # one templated bar.
  };

  xdg.configFile."zellij/layouts/default.kdl".source = pkgs.replaceVars ../static/zellij-default.kdl {
    ZJSTATUS = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  };

  # powerlevel10k config generated via `p10k configure`. Regenerate by running
  # the wizard, then copy ~/.config/zsh/.p10k.zsh back to config/zsh/p10k.zsh.
  xdg.configFile."zsh/.p10k.zsh".source = ../../../config/zsh/p10k.zsh;
  programs = {

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
  };

  # KDL syntax highlighting for bat. A hand-rolled minimal sublime-syntax —
  # the upstream eugenesvk/sublime-kdl package has a multi-file dispatch
  # structure (and a U+2044 character in one filename) that syntect can't
  # compile cleanly.
  xdg.configFile."bat/syntaxes/kdl.sublime-syntax".source = ../static/kdl.sublime-syntax;

  programs = {

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

  services.ssh-agent.enable =
    pkgs.stdenv.isLinux
    && !(config.services.gpg-agent.enable && config.services.gpg-agent.enableSshSupport);

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          ServerAliveInterval = "60";
          ServerAliveCountMax = "3";
        };
        setEnv = {
          TERM = "xterm-256color";
        };
      };
    };
  };

}
