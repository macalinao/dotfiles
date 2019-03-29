{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Editors
    emacs
    vim
  ] ++ (stdenv.lib.optionals (!stdenv.isDarwin) [
    # Media
    google-chrome
    vlc

    # Comms
    slack
    discord
    signal-desktop
  ]);
}