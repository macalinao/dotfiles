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

  nixpkgs.overlays = [ inputs.self.overlays.default ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkg.pname or "") [
      "claude-code"
      "codex"
    ];

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    tmux
    curl
    wget
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
