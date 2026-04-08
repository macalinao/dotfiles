{
  additionalOverlays ? [ ],
  isDarwin ? false,
  allowBroken ? false,
}:
{
  config = {
    inherit allowBroken;
    allowUnfree = true;
    pulseaudio = !isDarwin;
  };

  overlays = additionalOverlays;
}
