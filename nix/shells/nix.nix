{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs =
    [
      coreutils-full
      nixpkgs-fmt
      shfmt
      (yarn.override {
        nodejs = nodejs-18_x;
      })
      nodejs-18_x
    ];
}
