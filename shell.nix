with import <nixpkgs> { };
mkShell { nativeBuildInputs = [ coreutils-full nixfmt ]; }
