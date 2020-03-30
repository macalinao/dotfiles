{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    docker-compose
    git
    jq
    parallel
    protobuf
    silver-searcher
    tmux
    yq

    # Scala
    coursier
    sbt
    scala

    # Node
    yarn
    nodejs-12_x

    # Java
    openjdk8

    # Python (needed for node-gyp)
    python
    python36Packages.virtualenv

    # Dhall
    haskellPackages.dhall
    # haskellPackages.dhall-json

    # Persistence
    # postgresql
    redis

    # stuff
    grpcurl
    grpcui
    openssl
    gnupg
    heroku
    emscripten
    google-cloud-sdk

    # go
    go
  ];
}
