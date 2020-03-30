with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "node";
    buildInputs = [
        # Node
        yarn
        nodejs-12_x
    ];
  };
}
