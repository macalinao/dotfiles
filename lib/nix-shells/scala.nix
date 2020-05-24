with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "haskell";
    buildInputs = [
      # Scala
      coursier
      sbt
      scala
    ];
  };
}
