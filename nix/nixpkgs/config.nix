{
  self,
  allowUnfree ? true,
  allowUnfreePredicate ? null,
}:
{
  config =
    if allowUnfreePredicate != null then
      { inherit allowUnfreePredicate; }
    else
      { inherit allowUnfree; };

  overlays = [ self.overlays.default ];
}
