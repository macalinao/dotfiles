with import <nixpkgs> {}; {
  devEnv = stdenv.mkDerivation {
    name = "tex";
    buildInputs = [
      texlive.combined.scheme-basic
    ];
  };
}
