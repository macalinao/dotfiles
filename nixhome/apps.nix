{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    emacs
    vim
  ] ++ (stdenv.lib.optionals (!stdenv.isDarwin) [
    # Browsers
    brave
    chromium
    google-chrome
    (callPackage ./programs/cypress.nix {})

    # Media
    spotify
    vlc

    # Comms
    slack
    discord
    signal-desktop

    # Developer
    terminator

    # Etc
    rofi
  ]) ++ (stdenv.lib.optionals (stdenv.isDarwin) [
    # iterm2
  ]);
}
