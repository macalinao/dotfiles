{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    git
    jq
    # parallel
    # protobuf
    silver-searcher
    # tmux

    # Java
    # openjdk8

    # Python (needed for node-gyp)
    # python
    # python36Packages.virtualenv

    # Dhall
    # haskellPackages.dhall
    # haskellPackages.dhall-json

    # Persistence
    # postgresql
    # redis

    # stuff
    # grpcurl
    # grpcui
    # openssl
    # gnupg
    # emscripten
  ];
}
