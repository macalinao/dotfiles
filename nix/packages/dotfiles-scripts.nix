{
  stdenvNoCC,
  gnused,
  dotfilesPath,
}:

stdenvNoCC.mkDerivation {
  name = "dotfiles-scripts";
  src = ../../scripts;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp igm-helpers.sh $out/lib/
    for f in $(find . -maxdepth 1 -executable -type f ! -name '*.sh'); do
      script="$out/bin/$(basename $f)"
      cp "$f" "$script"
    done
    # Patch scripts: inject DOTFILES, replace helpers source path
    for f in $out/bin/*; do
      # Replace hardcoded DOTFILES derivations with the known path
      substituteInPlace "$f" \
        --replace-quiet 'DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"' 'DOTFILES="''${DOTFILES:-${dotfilesPath}}"' \
        --replace-quiet 'DOTFILES=$HOME/dotfiles' 'DOTFILES="''${DOTFILES:-${dotfilesPath}}"' \
        --replace-quiet 'source $DOTFILES/scripts/igm-helpers.sh' "source $out/lib/igm-helpers.sh" \
        --replace-quiet 'source "$DOTFILES/scripts/igm-helpers.sh"' "source $out/lib/igm-helpers.sh"
      # Inject DOTFILES default for scripts that don't set it
      if ! grep -q 'DOTFILES=' "$f"; then
        ${gnused}/bin/sed -i '1 a\DOTFILES="''${DOTFILES:-${dotfilesPath}}"' "$f"
      fi
    done
  '';
}
