{ ... }:
{
  flake = {
    homeModules = {
      default = import ../home/modules;
      headless = import ../home/modules/headless.nix;
    };
  };
}
