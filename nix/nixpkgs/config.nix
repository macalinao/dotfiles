{ additionalOverlays ? [ ]
, isDarwin ? false
, allowBroken ? false
}: {
  config = {
    inherit allowBroken;
    allowUnfree = true;
    pulseaudio = !isDarwin;
  };

  overlays = [ (import ./overlays/10-basic.nix) (import ./overlays/30-pia.nix) ]
    ++ additionalOverlays;
}
