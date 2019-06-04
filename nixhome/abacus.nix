{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-11_x; };
    };
  };

  home.packages = with pkgs; [
    # Dev
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
    nodejs-11_x

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
  ];
}
