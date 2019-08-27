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
    nodejs-11_x

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
    haskellPackages.cabal2nix
    haskellPackages.cabal-install
    haskellPackages.styx
    proto3-suite

    # stuff
    grpcurl
    openssl
    gnupg
  ];
}
