# This shell contains several useful utilities for interacting with the Pipe codebase.
with import <nixpkgs> { };
let
  nativeBuildInputs = [
    # frontend
    (yarn.override { nodejs = nodejs-14_x; })
    nodejs-14_x

    # backend
    go
    goreman
    stdenv
    zsh
    pg_flame
    postgresql_12

    # Golang tools
    delve
    go-outline
    go-symbols
    gocode
    gocode-gomod
    godef
    goimports
    golangci-lint
    gopkgs
    gopls

    # devops
    heroku

    # dev
    docker-compose
  ];
  drvArgs = if stdenv.isDarwin then {
    nativeBuildInputs = nativeBuildInputs ++ [
      # osx stuff
      darwin.apple_sdk.frameworks.CoreFoundation
    ];
    CFLAGS="-I/usr/include";
    LDFLAGS="-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks";
  } else {
    nativeBuildInputs = nativeBuildInputs;
  };
in stdenv.mkDerivation (drvArgs // {
    name = "dev";
})