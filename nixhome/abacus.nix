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

    # Devops
    awscli
    aws-iam-authenticator
    jx
    kubernetes
  ];
}
