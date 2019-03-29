{ pkgs, ... }:

{
  home.packages = with pkgs; [
  ] ++ (stdenv.lib.optionals (!stdenv.isDarwin) [
    # Media
    google-chrome
    vlc

    # Editors
    emacs
    vim

    # Comms
    slack
    discord
    signal-desktop
  ]);
}