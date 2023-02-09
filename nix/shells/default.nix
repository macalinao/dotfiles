{ pkgs }:
let
  shells = map (str: builtins.substring 0 ((builtins.stringLength) str - 4) str) (builtins.filter (x: x != "default") (builtins.attrNames (builtins.readDir ./.)));
  shellsMap = builtins.listToAttrs (map
    (shell:
      let drv = import ./${shell}.nix;
      in
      {
        name = shell;
        value = drv {
          inherit pkgs;
        };
      }
    )
    shells);
  full = pkgs.buildEnv {
    name = "full";
    paths = builtins.attrValues shellsMap;
  };
in
shellsMap // {
  inherit full;
  default = shellsMap.nix;
}
