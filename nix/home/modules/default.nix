{ inputs }:
{
  imports = [
    (import ../common.nix { inherit inputs; })
    ../os-specific/nixos/standard.nix
    ../os-specific/nixos/gui.nix
    ../os-specific/darwin.nix
    ./asimeow.nix
  ];
}
