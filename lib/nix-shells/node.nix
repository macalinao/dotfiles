with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "node";
    buildInputs = [
        # Node
        yarn
        nodejs-12_x
    ];
    CFLAGS="-I/usr/include";
    LDFLAGS="-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks";
  };
}
