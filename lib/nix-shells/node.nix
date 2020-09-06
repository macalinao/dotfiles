with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "node";
    buildInputs = [
        # Node
        yarn
        nodejs-14_x
    ];
    CFLAGS = if stdenv.isDarwin then "-I/usr/include" else "";
    LDFLAGS = if stdenv.isDarwin then "-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks" else "";
  };
}
