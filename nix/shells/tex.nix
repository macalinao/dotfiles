{ pkgs }:
with pkgs;
mkShell {
  name = "tex";
  buildInputs = [ texlive.combined.scheme-basic ];
}
