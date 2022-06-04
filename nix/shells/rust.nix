{ pkgs }:
with pkgs;
mkShell {
  name = "devshell-rust";
  buildInputs = [
    rustup
    pkg-config
    openssl
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
}
