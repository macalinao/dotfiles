{ pkgs }:
with pkgs;

let
  nodejs = nodejs_22;
in
mkShell {
  nativeBuildInputs = [
    git
    coreutils-full
    nixfmt
    shfmt
    (pnpm.override {
      inherit nodejs;
    })
    nodejs
  ];
}
