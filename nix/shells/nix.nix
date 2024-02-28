{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs =
    [
      coreutils-full
      nixpkgs-fmt
      shfmt
      (yarn.override {
        nodejs = nodejs_20;
      })
      nodejs_20
    ];
}
