{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    # Node
    yarn
    nodejs_22

    # Deno
    # deno
  ];
}
