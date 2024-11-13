{ pkgs }:
with pkgs;
mkShell {
  name = "devshell-rust";
  buildInputs =
    [
      rustup
      pkg-config
      openssl
      cargo-hakari
      cargo-outdated
      cargo-readme
      cargo-workspaces
    ]
    ++ (lib.optional stdenv.isDarwin (
      [ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [
        DiskArbitration
        Foundation
      ])
    ));

  packages = [
    cargo-expand
  ];
}
