{ pkgs }:
with pkgs;
mkShell {
  nativeBuildInputs = [
    # Scala
    coursier
    sbt
    scala
  ];
}
