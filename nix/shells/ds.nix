{ pkgs }:
with pkgs;
let
  jupyter = python311.withPackages (
    ps: with ps; [
      jupyterlab-server
      jupyter-core
      jupyter
      ipython
      ipykernel
      notebook
      matplotlib
      numpy
      toolz
      pandas
    ]
  );
in
mkShell { nativeBuildInputs = [ jupyter ]; }
