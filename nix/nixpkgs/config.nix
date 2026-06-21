{
  self,
  isDarwin ? false,
  pulseaudio ? !isDarwin,
  allowUnfree ? true,
  allowUnfreePredicate ? null,
}:
{
  config = {
    inherit pulseaudio;
  }
  // (
    if allowUnfreePredicate != null then { inherit allowUnfreePredicate; } else { inherit allowUnfree; }
  );

  overlays = [ self.overlays.default ];
}
