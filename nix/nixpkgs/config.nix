{ overlays ? [ ] }: {
  config = {
    allowUnfree = true;
    pulseaudio = true;
  };

  overlays = overlays ++ [
    (import ./overlays/1-basic.nix)
    (import ./overlays/2-scripts.nix)
    (import ./overlays/3-pia.nix)
  ];
}
