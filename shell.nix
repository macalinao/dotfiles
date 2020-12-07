with import <nixpkgs> { };
mkShell {
    nativeBuildInputs = [
        nixfmt
    ];
}