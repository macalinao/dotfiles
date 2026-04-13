{ inputs, ... }:
let
  nixpkgsConfig = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [ inputs.self.overlays.default ];
  };
in
{
  flake = {
    homeModules = {
      default = {
        imports = [
          ../home/modules
          nixpkgsConfig
        ];
      };
      headless = {
        imports = [
          ../home/modules/headless.nix
          nixpkgsConfig
        ];
      };
    };
  };
}
