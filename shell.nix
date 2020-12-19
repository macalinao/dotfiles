with import <nixpkgs> { };
let
  nix-pre-commit-hooks = import (fetchFromGitHub {
    owner = "cachix";
    repo = "pre-commit-hooks.nix";
    rev = "d16e007e6bd263ba5899a9a425d76a78906570cd";
    sha256 = "1c0lv3yzq1kkqm4j37wl5hlawlsrj1413vkr1mdm661klad2sa0d";
  });

  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixfmt.enable = true;
      shellcheck.enable = true;
      prettier.enable = true;
    };
  };
in mkShell {
  nativeBuildInputs = [ coreutils-full nixfmt ];
  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
