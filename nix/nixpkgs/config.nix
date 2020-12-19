{
  config.allowUnfree = true;
  overlays =
    [ (import ./overlays/1-basic.nix) (import ./overlays/2-scripts.nix) ];
}
