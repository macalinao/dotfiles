with import <nixpkgs> { };
let
  jupyter = python37.withPackages (ps:
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
in {
  devEnv = stdenv.mkDerivation {
    name = "devops";
    buildInputs = [ jupyter ];
  };
}
