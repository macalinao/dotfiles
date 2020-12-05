with import ../pkgs.nix;
mkShell {
  nativeBuildInputs = [
    # Node
    yarn
    nodejs

    # Deno
    deno
  ];
  CFLAGS = if stdenv.isDarwin then "-I/usr/include" else "";
  LDFLAGS = if stdenv.isDarwin then
    "-L${darwin.apple_sdk.frameworks.CoreFoundation}/Library/Frameworks"
  else
    "";
}
