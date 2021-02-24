{ config, pkgs, lib, ... }:

{
  imports = [ ./os-specific.nix ./programs/vscode.nix ./dotfiles ];

  nixpkgs = import ../nixpkgs/config.nix;

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

    niv
    nixfmt
    pypi2nix

    imagemagick

    nxs
    full-system-update
    yq
  ];

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
      key = "F126F8E8";
    };
    userName = "Ian Macalinao";
    userEmail = "github@igm.pub";

    includes = lib.mapAttrsToList (profile: profileInfo: {
      path = "${pkgs.writeTextFile {
        name = "config";
        text = ''
          [user]
            email = "${profileInfo.email}"
          ${profileInfo.additionalGitConfig}
          ${lib.optionalString (profileInfo.additionalGitignore != "") ''
            [core]
              excludesFile = "${
                pkgs.writeTextFile {
                  name = "gitignore_global";
                  text = ''
                    # shared gitignore
                    ${builtins.readFile ./static/gitignore_global}

                    # Additional config for profile ${profile}
                    ${profileInfo.additionalGitignore}'';
                }
              }"
          ''}
        '';
      }}";
      condition = "gitdir:~/proj/${profileInfo.githubOrganization}/";
    }) pkgs.dotfiles-private.profiles;
  };

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
      plugins = [ "git" "yarn" "gitignore" ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [ "osx" ]);
    };
    initExtra = ''
      ${lib.optionalString pkgs.stdenv.isDarwin ''
        bindkey '^[[1;3C' forward-word
        bindkey '^[[1;3D' backward-word
      ''}
      ${builtins.readFile ./static/shell-utils.zsh};
      ${builtins.readFile "${pkgs.dotfiles-private.src}/helpers.zsh"}
    '';
    envExtra = ''
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ];
      then
        . $HOME/.nix-profile/etc/profile.d/nix.sh
      fi
      . /etc/static/zshrc
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    '';

    sessionVariables = { DOTFILES = "${config.home.homeDirectory}/dotfiles"; };

    shellAliases = {
      gac = "git add -A $(git root) && git commit -m";
      gj = "cd $(git root)";
      gd = "git diff";
      gs = "gst";

      ls = "exa";
      l = "exa -lah";

      x = "exit";
      c = "clear";

      tf = "terraform";
      pbstack = "pbpaste | jq .stack_trace | unescape.py";
      docker_killall = "docker kill $(docker ps -q)";
      vi = "vim";
      dylan = "keybase chat send dylanmacalinao";
      unescape = "jq -r .";
      localip =
        "ifconfig | grep -Eo 'inet (addr:)?([0-9]*.){3}[0-9]*' | grep -Eo '([0-9]*.){3}[0-9]*' | grep -v '127.0.0.1'";
      funky = "sfxl fortnite";

      nsc = "cat package.json | jq .scripts";
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
}
