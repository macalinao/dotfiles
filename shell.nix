{ pkgs, nix-pre-commit-hooks }:
with pkgs;
let
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixfmt.enable = true;
      shellcheck.enable = true;
      prettier.enable = true;
    };
  };
in mkShell {
  nativeBuildInputs = [ coreutils-full nixfmt wally-cli ];
  shellHook = ''
    ${pre-commit-check.shellHook}
  '';
}
