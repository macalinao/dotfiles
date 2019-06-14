{ pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-11_x; };
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: rec {
          range-set-list =
            haskellPackagesNew.callPackage ./programs/range-set-list.nix { };

          proto3-wire =
            haskellPackagesNew.callPackage ./programs/proto3-wire.nix { };

          proto3-suite =
            pkgs.haskell.lib.dontCheck (
              haskellPackagesNew.callPackage ./programs/proto3-suite.nix { }
            );
        };
      };
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

    # build
    haskellPackages.cabal2nix
    haskellPackages.cabal-install
    haskellPackages.styx
    haskellPackages.proto3-suite
    haskellPackages.proto3-wire
  ];
}
