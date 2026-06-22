{ inputs }:

{ pkgs, ... }:

{
  imports = [
    ../../nix-settings-shared.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs = import ../../nixpkgs/config.nix {
    self = inputs.self;
    # Keep pulseaudio = true (the prior effective value via `!isDarwin`).
    # Flipping it to false rebuilds every pulseaudio-touching package
    # (libopenmpt, ffmpeg, SDL, …) as `--without-pulseaudio`, a non-default
    # variant the binary caches don't carry — which cascades the whole
    # downstream closure (incl. torch/opencv-CUDA) off cache.nixos.org /
    # cache.nixos-cuda.org into a from-source rebuild. Headless hosts still
    # run audio services (Kokoro TTS, the PowerConf voice satellite).
    pulseaudio = true;
    allowUnfreePredicate =
      pkg:
      builtins.elem (pkg.pname or "") [
        "claude-code"
        "codex"
      ];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    iotop-c
    tmux
    curl
    wget
  ];

  # nix-direnv (`use flake`) leaks /tmp/nix-shell.* dirs when shells exit
  # abnormally; systemd's default /tmp cleanup is 10d, which lets thousands
  # accumulate. Trim ones older than 1 day daily.
  systemd.services.cleanup-nix-shell-tmpdirs = {
    description = "Remove stale /tmp/nix-shell.* directories";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.findutils}/bin/find /tmp -maxdepth 1 -name 'nix-shell.*' -type d -mtime +1 -exec rm -rf {} +";
    };
  };

  systemd.timers.cleanup-nix-shell-tmpdirs = {
    description = "Periodic cleanup of stale /tmp/nix-shell.* directories";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "10m";
      OnUnitActiveSec = "1d";
      Persistent = true;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
