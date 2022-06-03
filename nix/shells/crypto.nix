{ pkgs }:
with pkgs;
mkShell {
  name = "crypto";
  buildInputs = [ go-ethereum ];
}
