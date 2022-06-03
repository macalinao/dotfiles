{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs =
    [ coreutils-full nixpkgs-fmt wally-cli shfmt yarn nodejs ];
}
