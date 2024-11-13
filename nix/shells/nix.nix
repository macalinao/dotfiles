{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    git
    coreutils-full
    nixfmt-rfc-style
    shfmt
    (yarn.override {
      nodejs = nodejs_22;
    })
    nodejs_22
  ];
}
