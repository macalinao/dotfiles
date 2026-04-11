{ inputs, ... }:
let
  inherit (inputs)
    additional-nix-packages
    claude-code-nix
    codex-cli-nix
    ;
in
{
  flake.overlays = {
    default = inputs.nixpkgs.lib.composeManyExtensions [
      (self: _super: {
        additional-nix-packages = additional-nix-packages.packages.${self.stdenv.hostPlatform.system};
      })
      claude-code-nix.overlays.default
      codex-cli-nix.overlays.default
    ];
  };
}
