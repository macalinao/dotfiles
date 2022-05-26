{ additionalOverlays ? [ ], isDarwin ? false }: {
  config = {
    allowUnfree = true;
    pulseaudio = !isDarwin;
  };

  overlays = [ (import ./overlays/10-basic.nix) (import ./overlays/30-pia.nix) ]
    ++ additionalOverlays;
}
