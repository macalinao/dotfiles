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
  CFLAGS = if stdenv.isDarwin then "-I/usr/include" else "";
  LDFLAGS =
    if stdenv.isDarwin then
      "-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks"
    else
      "";
}
