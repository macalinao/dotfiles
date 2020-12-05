{ pkgs, python }:

self: super:
let
  addPropagatedBuildInputs = packages: old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ packages;
  };
  overridePythonPackage = name: overrides:
    let
      combinedOverrides = old:
        pkgs.lib.fold (override: previous: previous // override previous) old
        overrides;
    in python.overrideDerivation super."${name}" combinedOverrides;
in {
  "migra" = overridePythonPackage "migra"
    [ (addPropagatedBuildInputs [ self."psycopg2-binary" self."setuptools" ]) ];
}
