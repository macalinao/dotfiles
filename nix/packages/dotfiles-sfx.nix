{
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  name = "dotfiles-sfx";
  src = ../../sfx;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sfx
    cp -r ./* $out/share/sfx/
  '';
}
