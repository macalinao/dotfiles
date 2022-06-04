{ pkgs }:
with pkgs;
let
  jupyter = python39.withPackages (ps:
    with ps; [
      jupyterlab_server
      jupyter_core
      jupyter
      ipython
      ipykernel
      notebook
      matplotlib
      numpy
      toolz
      pandas
    ]);
in
mkShell { nativeBuildInputs = [ jupyter ]; }
