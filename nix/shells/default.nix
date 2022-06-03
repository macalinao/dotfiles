{ pkgs }:
let
  files = map (str: builtins.substring 0 ((builtins.stringLength) str - 4) str) (builtins.filter (x: x != "default") (builtins.attrNames (builtins.readDir ./.)));
  _ = builtins.trace (builtins.readDir ./.);
  shells = [ "crypto" "rust" "nix" ] ++ files;
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
in
shellsMap // {
  default = shellsMap.nix;
}
