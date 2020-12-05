# This shell contains several useful utilities for interacting with the Pipe codebase.
with import ../pkgs.nix;
let
  nativeBuildInputs = [
    # frontend
    yarn
    nodejs

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
in mkShell drvArgs