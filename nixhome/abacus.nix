{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-10_x; };
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
    sbt
    scala

    # Node
    yarn
    nodejs-10_x

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
    sops

    # Crypto
    go-ethereum

    # Persistence
    postgresql
    redis
  ];
}
