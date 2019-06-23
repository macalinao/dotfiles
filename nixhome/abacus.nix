{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      jx = pkgs.callPackage ./programs/jx.nix { };

      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; };

      proto3-suite = pkgs.callPackage ./programs/proto3-suite.nix { };
    };
  };

  home.packages = with pkgs; [
    # Dev
    docker-compose
    git
    jq
    parallel
    protobuf
    silver-searcher
    tmux

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
    haskellPackages.dhall-json

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
