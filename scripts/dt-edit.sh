# dt-edit — render photos through darktable film-emulation styles, headless.
#
# Applies the Nix-managed style packs (t3mujinpack + One Camera One Lens) to an
# image using darktable-cli, with no GUI and no style import required: each
# .dtstyle is converted to an .xmp sidecar on the fly (see dtstyle2xmp.py) and
# fed to darktable-cli directly. Works on RAW (CR3, etc.) or JPEG.
#
# DTSTYLE2XMP (path to the converter) and darktable-cli/python3 are provided by
# the Nix wrapper that sources this file.

PROG=dt-edit
WIDTH_PREVIEW=1200
WIDTH_FULL=0 # 0 = full resolution
STYLES_DIR="${DARKTABLE_STYLES_DIR:-$HOME/.config/darktable/styles-packs}"

die() {
  echo "$PROG: $*" >&2
  exit 1
}

usage() {
  cat >&2 <<EOF
dt-edit — render photos through darktable film-emulation styles (headless)

usage:
  dt-edit list                       list available style names
  dt-edit contact IMAGE [OUTDIR]     render a curated sample of looks
                                     (default OUTDIR: ./dt-contact)
  dt-edit all IMAGE [OUTDIR]         render IMAGE through every style
                                     (default OUTDIR: ./dt-all)
  dt-edit apply IMAGE QUERY [OUTDIR] render the style matching QUERY at full
                                     resolution (default OUTDIR: .)

IMAGE may be RAW (CR3, NEF, ...) or JPEG. Styles are read from:
  $STYLES_DIR
EOF
}

label_of() { basename "$1" .dtstyle; }

sanitize() { printf '%s' "$1" | tr -c 'A-Za-z0-9._-' '_'; }

# render IMAGE STYLEFILE OUTFILE WIDTH  -> 0 on success
render() {
  local image=$1 style=$2 out=$3 width=$4
  local tmp xmp cfg
  tmp=$(mktemp -d)
  xmp="$tmp/style.xmp"
  cfg="$tmp/config"
  mkdir -p "$cfg"
  python3 "$DTSTYLE2XMP" "$style" "$xmp" >/dev/null || {
    rm -rf "$tmp"
    return 1
  }
  # Isolated configdir + in-memory library so concurrent/repeat runs never
  # touch (or lock) the user's real darktable database.
  darktable-cli "$image" "$xmp" "$out" \
    --width "$width" --out-ext jpg \
    --core --configdir "$cfg" --library ":memory:" >/dev/null 2>&1
  local rc=$?
  rm -rf "$tmp"
  return $rc
}

# render a list of style files to OUTDIR at WIDTH, echoing progress
render_set() {
  local image=$1 outdir=$2 width=$3
  shift 3
  local base n=0 lbl
  base=$(basename "$image")
  base=${base%.*}
  mkdir -p "$outdir"
  local style
  for style in "$@"; do
    lbl=$(sanitize "$(label_of "$style")")
    if render "$image" "$style" "$outdir/${base}__${lbl}.jpg" "$width"; then
      echo "ok: $lbl"
      n=$((n + 1))
    else
      echo "FAILED: $lbl" >&2
    fi
  done
  echo "rendered $n image(s) to $outdir"
}

[ -d "$STYLES_DIR" ] || die "styles dir not found: $STYLES_DIR (run igm-switch?)"
mapfile -t ALL_STYLES < <(find "$STYLES_DIR" -name '*.dtstyle' | sort)
[ "${#ALL_STYLES[@]}" -gt 0 ] || die "no .dtstyle files under $STYLES_DIR"

cmd=${1:-}
shift || true

case "$cmd" in
list)
  for s in "${ALL_STYLES[@]}"; do label_of "$s"; done
  ;;
contact)
  image=${1:-}
  [ -n "$image" ] || {
    usage
    exit 64
  }
  [ -f "$image" ] || die "no such file: $image"
  outdir=${2:-./dt-contact}
  # Curated, representative cross-section (substring match; first hit each).
  patterns=(
    "Color Slide_Fuji Velvia 50"
    "Color Slide_Fuji Provia 100F"
    "Color Slide_Fuji Astia 100F"
    "Color Negative_Kodak Portra 400"
    "Color Negative_Kodak Portra 160"
    "Color Negative_Kodak Ektar 100"
    "Color Negative_Fuji Superia 200"
    "Black and White_Ilford Delta 400"
    "_Velviatic"
    "_Pastel"
    "_Chrome It"
    "Basic Adjustments"
  )
  picks=()
  for pat in "${patterns[@]}"; do
    match=$(printf '%s\n' "${ALL_STYLES[@]}" | grep -F "$pat" | head -1)
    [ -n "$match" ] && picks+=("$match")
  done
  render_set "$image" "$outdir" "$WIDTH_PREVIEW" "${picks[@]}"
  ;;
all)
  image=${1:-}
  [ -n "$image" ] || {
    usage
    exit 64
  }
  [ -f "$image" ] || die "no such file: $image"
  outdir=${2:-./dt-all}
  render_set "$image" "$outdir" "$WIDTH_PREVIEW" "${ALL_STYLES[@]}"
  ;;
apply)
  image=${1:-}
  query=${2:-}
  { [ -n "$image" ] && [ -n "$query" ]; } || {
    usage
    exit 64
  }
  [ -f "$image" ] || die "no such file: $image"
  outdir=${3:-.}
  match=$(printf '%s\n' "${ALL_STYLES[@]}" | grep -iF "$query" | head -1)
  [ -n "$match" ] || die "no style matches: $query"
  mkdir -p "$outdir"
  base=$(basename "$image")
  base=${base%.*}
  lbl=$(sanitize "$(label_of "$match")")
  out="$outdir/${base}__${lbl}.jpg"
  if render "$image" "$match" "$out" "$WIDTH_FULL"; then
    echo "$out"
  else
    die "render failed for $(label_of "$match")"
  fi
  ;;
"" | -h | --help | help)
  usage
  ;;
*)
  die "unknown command: $cmd (try: dt-edit help)"
  ;;
esac
