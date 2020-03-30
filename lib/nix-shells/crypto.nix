with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "crypto";
    buildInputs = [
      go-ethereum
    ];
  };
}
