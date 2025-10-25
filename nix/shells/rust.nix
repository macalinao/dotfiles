{ pkgs }:
with pkgs;
mkShell {
  name = "devshell-rust";
  buildInputs = [
    rustup
    pkg-config
    openssl
    cargo-hakari
    cargo-outdated
    cargo-readme
    cargo-workspaces
  ]
  ++ (lib.optional stdenv.isDarwin ([
    libiconv
    apple-sdk
  ]));

  packages = [
    cargo-expand
  ];
}
