{ pkgs }:
with pkgs;
mkShell {
  name = "solana";
  buildInputs = [ solana-1_10-basic goki-cli ];
}
