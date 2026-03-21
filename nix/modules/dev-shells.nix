{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      shellFiles = builtins.removeAttrs (builtins.readDir ../shells) [ "default.nix" ];
      shells = builtins.listToAttrs (
        map (
          name:
          let
            shellName = builtins.substring 0 ((builtins.stringLength name) - 4) name;
          in
          {
            name = shellName;
            value = import ../shells/${name} { inherit pkgs; };
          }
        ) (builtins.attrNames shellFiles)
      );
    in
    {
      devShells = shells;
    };
}
