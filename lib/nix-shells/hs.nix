with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "haskell";
    buildInputs = [
      stack
    ];
  };
}
