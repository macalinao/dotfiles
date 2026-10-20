{ inputs, ... }:
let
  inherit (inputs)
    additional-nix-packages
    zjstatus
    ;
in
{
  flake.overlays = {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      (self: _super: {
        additional-nix-packages = additional-nix-packages.packages.${self.stdenv.hostPlatform.system};
        zjstatus = zjstatus.packages.${self.stdenv.hostPlatform.system}.default;
      })
    ];
  };
}
