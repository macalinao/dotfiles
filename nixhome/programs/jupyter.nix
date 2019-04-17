with import <nixpkgs> {};

python37.withPackages (ps: with ps; [
  jupyterlab
  jupyter_core
  jupyter
  ipython
  ipykernel
  notebook
  numpy
  toolz
  pandas
])
