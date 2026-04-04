# Full personal machine config — imports headless.nix, adds GUI/personal/hobby stuff.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./modules/headless.nix ];

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

  # Browser password management
  programs.browserpass.enable = true;
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };
}
