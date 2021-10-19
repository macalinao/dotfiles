{ additionalOverlays ? [ ] }: {
  config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  overlays = [ (import ./overlays/10-basic.nix) (import ./overlays/30-pia.nix) ]
    ++ additionalOverlays;
}
