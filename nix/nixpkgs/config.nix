{ additionalOverlays ? [ ]
, isDarwin ? false
, allowBroken ? false
}: {
  config = {
    inherit allowBroken;
    allowUnfree = true;
    pulseaudio = !isDarwin;
    # Needed to get home-manager-fonts working
    permittedInsecurePackages = [
      "python-2.7.18.6"
    ];
  };

  overlays = [ (import ./overlays/10-basic.nix) (import ./overlays/30-pia.nix) ]
    ++ additionalOverlays;
}
