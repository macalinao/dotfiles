{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs =
    [ coreutils-full nixpkgs-fmt shfmt yarn nodejs ];
}
