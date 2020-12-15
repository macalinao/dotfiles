with import <nixpkgs> { };
let
  nix-pre-commit-hooks = import (builtins.fetchTarball
    "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");

  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixfmt.enable = true;
      shellcheck.enable = true;
    };
  };
in mkShell {
  nativeBuildInputs = [ coreutils-full nixfmt ];
  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
