{ pkgs }:
with pkgs;
stdenvNoCC.mkDerivation {
  name = "devshell-rust";
  buildInputs = [
    rustup
    pkg-config
    openssl
  ] ++ (lib.optional stdenv.isDarwin [ libiconv ]);
}
