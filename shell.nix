{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [ coreutils-full nixfmt wally-cli shfmt yarn nodejs ];
}
