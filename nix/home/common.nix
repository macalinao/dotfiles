# Full personal machine config — imports headless.nix, adds GUI/personal/hobby stuff.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./headless.nix ];

  home.packages = with pkgs; [
    cmatrix
    stockfish
    android-tools
    proxmark3
    wally-cli
  ];

  programs.vscode = {
    enable = true;

    # WARNING: this is impure, so we only do this on Linux
    profiles.default.extensions =
      with pkgs.vscode-extensions;
      pkgs.lib.optionals pkgs.stdenv.isLinux [ rust-lang.rust-analyzer ];
  };

  # Personal git identity and signing
  programs.git.settings.user = {
    name = "Ian Macalinao";
    email = "github@igm.pub";
  };
  programs.git.signing = {
    signByDefault = true;
    key = "5A246DACA92D4485";
  };

  # Browser password management
  programs.browserpass.enable = true;
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
}
