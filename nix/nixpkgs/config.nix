{
  additionalOverlays ? [ ],
  isDarwin ? false,
}:
{
  config = {
    allowUnfree = true;
    pulseaudio = !isDarwin;
  };

  overlays = additionalOverlays;
}
