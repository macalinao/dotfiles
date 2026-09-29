# ccstatus — enumerate Claude Code OAuth accounts and their usage caps.
#
# Each `~/.claude*` config dir (`.claude`, `.claude-1`, `.claude-2`, …) is a
# separate logged-in Anthropic account. This walks them, reads the stored
# OAuth access token, and hits the usage endpoint to print the 5-hour and
# 7-day rate-limit utilization per account.
#
# Linux keeps the credentials in `<dir>/.credentials.json`. macOS keeps them
# in the login Keychain as `Claude Code-credentials-<sha256(dir)[:8]>` (plain
# `Claude Code-credentials` when CLAUDE_CONFIG_DIR is unset), falling back to
# the file. The first Keychain read may prompt; "Always Allow" silences it.
#
# Default scope is the caller's own $HOME. `--all` sweeps every home dir —
# reading another user's 0700 home needs root, so run it under sudo; dirs it
# can't read are silently skipped (so a plain `--all` just shows your own).
#
# All accounts are queried in parallel; the table is printed once every
# request has returned.
set -uo pipefail

usage() {
  cat >&2 <<'EOF'
usage: ccstatus [--all] [HOME_DIR ...]

  (no args)   scan the current user's $HOME
  --all, -a   scan every /home/* (/Users/* on macOS; sudo to read others)
  HOME_DIR    scan the given home dir(s), e.g. sudo ccstatus /home/phyg
EOF
}

homes=()
all=0
while [ $# -gt 0 ]; do
  case "$1" in
  -a | --all) all=1 ;;
  -h | --help)
    usage
    exit 0
    ;;
  -*)
    echo "ccstatus: unknown option: $1" >&2
    usage
    exit 2
    ;;
  *) homes+=("$1") ;;
  esac
  shift
done

darwin=0
[ "$(uname -s)" = Darwin ] && darwin=1

if [ "$all" -eq 1 ]; then
  homes_root=/home
  [ "$darwin" -eq 1 ] && homes_root=/Users
  for h in "$homes_root"/*; do
    [ -d "$h" ] && homes+=("$h")
  done
fi
[ ${#homes[@]} -eq 0 ] && homes+=("$HOME")

# A single owner => label rows by dir basename only (matches the simple
# table); multiple owners => prefix with the owning user.
show_owner=0
[ ${#homes[@]} -gt 1 ] && show_owner=1

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Print a config dir's credentials JSON: Keychain first on macOS, then the file.
readcreds() {
  local d=$1 svc
  if [ "$darwin" -eq 1 ]; then
    svc="Claude Code-credentials-$(printf '%s' "$d" | sha256sum | cut -c1-8)"
    /usr/bin/security find-generic-password -s "$svc" -w 2>/dev/null && return
    if [ "$d" = "$HOME/.claude" ]; then
      /usr/bin/security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null && return
    fi
  fi
  [ -f "$d/.credentials.json" ] && cat "$d/.credentials.json"
}

# Collect candidate config dirs (any .claude* with readable credentials),
# snapshotting each one's credentials serially so Keychain prompts don't race.
dirs=()
for h in "${homes[@]}"; do
  for d in "$h"/.claude "$h"/.claude-*; do
    [ -d "$d" ] || continue
    n=$(printf '%04d' $((${#dirs[@]} + 1)))
    if readcreds "$d" >"$tmp/creds-$n" && [ -s "$tmp/creds-$n" ]; then
      dirs+=("$d")
    fi
  done
done

if [ ${#dirs[@]} -eq 0 ]; then
  echo "ccstatus: no Claude config dirs with credentials found" >&2
  exit 1
fi

now=$(date +%s)
tzname=$(date +%Z)

# Unit-separator byte, used inside a reset cell to split the absolute date
# from its relative "(in 2h)" suffix so the formatter can dim just the latter.
US=$'\x1f'

# Local, human date from an ISO-8601 (or @epoch) timestamp, e.g. "Sep 15 14:00".
fmtdate() {
  date -d "$1" '+%b %-d %H:%M' 2>/dev/null || printf '%s' "$1"
}

# Coarse relative time (one unit) between an epoch target and now,
# e.g. "in 2h", "in 3d", "45m ago".
reltime() {
  local diff=$(($1 - now)) prefix="in " suffix="" val
  if [ "$diff" -lt 0 ]; then
    diff=$((-diff))
    prefix=""
    suffix=" ago"
  fi
  if [ "$diff" -ge 86400 ]; then
    val="$((diff / 86400))d"
  elif [ "$diff" -ge 3600 ]; then
    val="$((diff / 3600))h"
  else
    val="$((diff / 60))m"
  fi
  printf '%s%s%s' "$prefix" "$val" "$suffix"
}

# A reset cell: absolute local date + US + relative time (dimmed by the formatter).
# An absent window (resets_at null, e.g. an idle 5h bucket) yields an empty cell.
resetcell() {
  local iso=$1 epoch
  if [ -z "$iso" ] || [ "$iso" = null ]; then
    return
  fi
  epoch=$(date -d "$iso" +%s 2>/dev/null || echo "$now")
  printf '%s%s%s' "$(fmtdate "$iso")" "$US" "$(reltime "$epoch")"
}

# Emit one tab-separated row: ACCOUNT EMAIL 5H "5H RESET" 7D "7D RESET".
row() { printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" "$6"; }

fetch() {
  local d=$1 creds=$2 out=$3 label email tok exp resp parsed kind f5h r5h f7d r7d
  if [ "$show_owner" -eq 1 ]; then
    label="$(stat -c %U "$d" 2>/dev/null || echo '?'):${d##*/}"
  else
    label="${d##*/}"
  fi
  email=$(jq -r '.oauthAccount.emailAddress // "?"' "$d/.claude.json" 2>/dev/null || echo '?')
  tok=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)
  exp=$(jq -r '(.claudeAiOauth.expiresAt // 0) / 1000 | floor' "$creds" 2>/dev/null || echo 0)

  if [ -z "$tok" ]; then
    row "$label" "$email" "no token" "" "" "" >"$out"
    return
  fi
  if [ "$exp" -lt "$now" ]; then
    row "$label" "$email" "expired${US}$(reltime "$exp")" "" "" "" >"$out"
    return
  fi

  resp=$(curl -s --max-time 20 https://api.anthropic.com/api/oauth/usage \
    -H "Authorization: Bearer $tok" \
    -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)

  if [ -z "$resp" ]; then
    row "$label" "$email" "no response" "" "" "" >"$out"
    return
  fi

  # Split the JSON into shell fields so the reset dates can be localized.
  parsed=$(printf '%s' "$resp" | jq -r '
    if .error then "err\t\(.error.type)\t\t\t"
    else "ok\t\(.five_hour.utilization)\t\(.five_hour.resets_at)\t\(.seven_day.utilization)\t\(.seven_day.resets_at)"
    end' 2>/dev/null)
  if [ -z "$parsed" ]; then
    row "$label" "$email" "bad response" "" "" "" >"$out"
    return
  fi
  IFS=$'\t' read -r kind f5h r5h f7d r7d <<<"$parsed"
  if [ "$kind" = ok ]; then
    row "$label" "$email" "${f5h}%" "$(resetcell "$r5h")" "${f7d}%" "$(resetcell "$r7d")" >"$out"
  else
    row "$label" "$email" "error: $f5h" "" "" "" >"$out"
  fi
}

i=0
for d in "${dirs[@]}"; do
  i=$((i + 1))
  n=$(printf '%04d' "$i")
  fetch "$d" "$tmp/creds-$n" "$tmp/row-$n" &
done
wait

# Dim the relative-time suffix, but only on a terminal.
if [ -t 1 ]; then
  dim=$'\e[90m'
  rst=$'\e[0m'
else
  dim=""
  rst=""
fi

# Column-align on *visible* width: a cell "abs US rel" displays as "abs (rel)"
# with the "(rel)" dimmed; the escape codes must not count toward padding, so
# column(1) can't be used here.
{
  row "ACCOUNT" "EMAIL" "5H" "5H RESET ($tzname)" "7D" "7D RESET ($tzname)"
  cat "$tmp"/row-* | sort
} | awk -v US="$US" -v DIM="$dim" -v RST="$rst" '
  BEGIN { FS = "\t" }
  {
    nf[NR] = NF
    for (j = 1; j <= NF; j++) {
      p = index($j, US)
      if (p > 0) {
        abs = substr($j, 1, p - 1)
        rel = substr($j, p + 1)
        disp[NR, j] = abs " " DIM "(" rel ")" RST
        plen[NR, j] = length(abs) + length(rel) + 3
      } else {
        disp[NR, j] = $j
        plen[NR, j] = length($j)
      }
      if (plen[NR, j] > w[j]) w[j] = plen[NR, j]
    }
    rows = NR
  }
  END {
    for (i = 1; i <= rows; i++) {
      line = ""
      for (j = 1; j <= nf[i]; j++) {
        line = line disp[i, j]
        if (j < nf[i]) line = line sprintf("%*s", w[j] - plen[i, j] + 2, "")
      }
      print line
    }
  }
'
