{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    coreutils-full
    nixfmt-rfc-style
    shfmt
    (yarn.override {
      nodejs = nodejs_22;
    })
    nodejs_22
  ];
}
