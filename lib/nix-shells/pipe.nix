with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "dev";
    buildInputs = [
        yarn
        nodejs-12_x

        go
        go-outline
        goreman
        stdenv
        zsh

        darwin.apple_sdk.frameworks.CoreFoundation
        pg_flame
        postgresql_11
    ];
    CFLAGS="-I/usr/include";
    LDFLAGS="-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks";
  };
}
