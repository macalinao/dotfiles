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

    # Dhall
    haskellPackages.dhall
    # haskellPackages.dhall-json

    # Devops
    aws-iam-authenticator
    awscli
    jx
    kops
    kubernetes
    kubernetes-helm
    skaffold
    sops
    terraform
    terraform-providers.aws

    # Crypto
    go-ethereum

    # Persistence
    # postgresql
    redis

    # build
    proto3-suite

    # stuff
    grpcurl
    grpcui
    openssl
    gnupg
    heroku
  ];
}
