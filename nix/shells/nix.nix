{ pkgs }:
with pkgs;

let
  nodejs = nodejs_22;
in
mkShell {
  nativeBuildInputs = [
    git
    coreutils-full
    nixfmt-rfc-style
    shfmt
    (pnpm.override {
      inherit nodejs;
    })
    nodejs
    (yarn.override {
      inherit nodejs;
    })
  ];
}
