{ pkgs }:
mkShell {
  name = "crypto";
  buildInputs = [ go-ethereum ];
}
