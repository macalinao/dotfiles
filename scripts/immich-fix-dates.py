#!/usr/bin/env python3
"""
immich-fix-dates -- reconcile Immich capture dates against Apple Photos.

Why this exists
---------------
A bulk migration of an Apple Photos library into Immich exported UUID-named
originals straight from the library bundle WITHOUT baking Apple's database
capture date into the files. Dateless files (no EXIF DateTimeOriginal) then fell
back to the file modification time -- the export date -- so a large batch of
photos all landed on the migration day instead of when they were actually taken.

Apple Photos still holds the true capture date in its database, and the Immich
`originalFileName` is the Apple UUID (e.g. C2124B02-...-....jpeg). So we ask
osxphotos for every UUID's authoritative date and push corrections to Immich.

Safe by construction
--------------------
For every Immich asset whose originalFileName is an Apple UUID we recognise, we
set dateTimeOriginal to Apple's date -- but ONLY when it differs from Immich's
current date by more than --diff-days. A photo genuinely taken on the migration
day (Apple's own date matches) already agrees and is skipped. Assets that kept a
real filename (IMG_1234.JPG, not a UUID) are never touched.

Dry-run by default. Pass --apply to write. A full plan CSV is always written.

Requirements: osxphotos on PATH (uv tool install osxphotos), python3, and an
Immich API key -- read from ~/.config/immich/auth.yml (the file `immich
login-key` writes) unless IMMICH_URL / IMMICH_KEY are set.

Usage:
  immich-fix-dates                 # dry run: scan, write plan, change nothing
  immich-fix-dates --apply         # apply every correction in the plan
  immich-fix-dates --apply --limit 20   # apply a small test batch first
  immich-fix-dates --diff-days 1   # only correct deltas larger than 1 day (default)
"""
import argparse
import csv
import datetime as dt
import http.client
import json
import os
import ssl
import subprocess
import sys
import tempfile
import urllib.parse

AUTH_PATH = os.path.expanduser("~/.config/immich/auth.yml")


def load_auth():
    """Resolve Immich url+key from env, falling back to immich-cli's auth.yml."""
    url = os.environ.get("IMMICH_URL")
    key = os.environ.get("IMMICH_KEY")
    if not (url and key):
        try:
            for line in open(AUTH_PATH):
                s = line.strip()
                if s.startswith("url:") and not url:
                    url = s.split(":", 1)[1].strip()
                elif s.startswith("key:") and not key:
                    key = s.split(":", 1)[1].strip()
        except FileNotFoundError:
            pass
    if not (url and key):
        sys.exit(
            f"No Immich credentials. Set IMMICH_URL/IMMICH_KEY or run "
            f"`immich login-key <url> <key>` to populate {AUTH_PATH}."
        )
    return url.rstrip("/"), key


class Immich:
    def __init__(self, url, key, resolve_ip=""):
        p = urllib.parse.urlparse(url)
        self.host = p.hostname
        self.port = p.port or (443 if p.scheme == "https" else 80)
        self.base = p.path.rstrip("/")  # e.g. "/api"
        self.key = key
        self.resolve_ip = resolve_ip
        self.ctx = ssl.create_default_context()

    def _conn(self):
        target = self.resolve_ip or self.host
        return http.client.HTTPSConnection(target, self.port, timeout=60, context=self.ctx)

    def request(self, method, path, body=None):
        c = self._conn()
        headers = {"x-api-key": self.key, "Accept": "application/json", "Host": self.host}
        data = None
        if body is not None:
            data = json.dumps(body).encode()
            headers["Content-Type"] = "application/json"
        c.request(method, self.base + path, body=data, headers=headers)
        r = c.getresponse()
        raw = r.read()
        c.close()
        if r.status >= 300:
            raise RuntimeError(f"{method} {path} -> {r.status}: {raw[:300].decode(errors='replace')}")
        return json.loads(raw) if raw else None

    def iter_assets(self):
        page = 1
        while True:
            res = self.request("POST", "/search/metadata", {"page": page, "size": 1000, "withExif": True})
            assets = (res or {}).get("assets", {})
            for a in assets.get("items", []):
                yield a
            nxt = assets.get("nextPage")
            if not nxt:
                break
            page = int(nxt)


def build_apple_map():
    """Run osxphotos and return {UPPER_UUID: iso_date_str} for the whole library."""
    print("Querying Apple Photos via osxphotos (this takes a minute)...", file=sys.stderr)
    with tempfile.NamedTemporaryFile("w+", suffix=".csv", delete=False) as tf:
        csv_path = tf.name
    # `osxphotos query` with no filter emits the full library as CSV on stdout.
    # (--quiet suppresses the CSV too, so we don't pass it; progress goes to stderr.)
    with open(csv_path, "w") as out:
        proc = subprocess.run(["osxphotos", "query"], stdout=out, stderr=subprocess.DEVNULL)
    if proc.returncode != 0:
        sys.exit(f"osxphotos query failed (exit {proc.returncode}). Is osxphotos installed and Photos access granted?")
    umap = {}
    with open(csv_path, newline="") as f:
        for row in csv.DictReader(f):
            u = (row.get("uuid") or "").strip().upper()
            d = (row.get("date") or "").strip()
            if u and d:
                umap[u] = d
    os.unlink(csv_path)
    print(f"  {len(umap)} photos in Apple library", file=sys.stderr)
    return umap


def parse_iso(s):
    if not s:
        return None
    s = s.strip()
    if s.endswith("Z"):
        s = s[:-1] + "+00:00"
    try:
        return dt.datetime.fromisoformat(s)
    except ValueError:
        try:
            return dt.datetime.fromisoformat(s.split(".")[0])
        except ValueError:
            return None


def uuid_from_name(name):
    """Return the UPPER-case Apple UUID if `name` is a UUID-named file, else None."""
    if not name:
        return None
    stem = name.rsplit(".", 1)[0].strip().upper()
    segs = stem.split("-")
    if len(segs) == 5 and len(stem) == 36 and all(
        all(ch in "0123456789ABCDEF" for ch in g) for g in segs
    ):
        return stem
    return None


def main():
    ap = argparse.ArgumentParser(
        description="Reconcile Immich capture dates against Apple Photos (osxphotos).",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    ap.add_argument("--apply", action="store_true", help="write corrections (default: dry run)")
    ap.add_argument("--diff-days", type=float, default=1.0,
                    help="only correct assets whose date differs by more than this many days (default 1)")
    ap.add_argument("--limit", type=int, default=0, help="cap the number of assets corrected (test batches)")
    ap.add_argument("--plan", default=os.path.expanduser("~/immich-date-plan.csv"),
                    help="where to write the change plan CSV")
    ap.add_argument("--resolve-ip", default=os.environ.get("RESOLVE_IP", ""),
                    help="pin the Immich host to this IP (bypasses broken DNS)")
    args = ap.parse_args()

    url, key = load_auth()
    api = Immich(url, key, resolve_ip=args.resolve_ip)
    api.request("GET", "/server/ping")
    print(f"Connected: {url}  apply={args.apply}  diff_days={args.diff_days}", file=sys.stderr)

    umap = build_apple_map()

    plan = []
    seen = matched = 0
    for a in api.iter_assets():
        seen += 1
        u = uuid_from_name(a.get("originalFileName") or "")
        if not u or u not in umap:
            continue
        matched += 1
        apple_iso = umap[u]
        apple_dt = parse_iso(apple_iso)
        if not apple_dt:
            continue
        exif = a.get("exifInfo") or {}
        cur_iso = exif.get("dateTimeOriginal") or a.get("localDateTime") or a.get("fileCreatedAt")
        cur_dt = parse_iso(cur_iso)
        delta = None
        if cur_dt:
            ad = apple_dt if apple_dt.tzinfo else apple_dt.replace(tzinfo=dt.timezone.utc)
            cd = cur_dt if cur_dt.tzinfo else cur_dt.replace(tzinfo=dt.timezone.utc)
            delta = abs((ad - cd).total_seconds()) / 86400.0
        if delta is not None and delta <= args.diff_days:
            continue
        plan.append({
            "id": a["id"],
            "originalFileName": a.get("originalFileName") or "",
            "uuid": u,
            "immich_current": cur_iso or "",
            "apple_correct": apple_iso,
            "delta_days": "" if delta is None else f"{delta:.1f}",
        })

    plan.sort(key=lambda r: r["apple_correct"])
    fields = ["id", "originalFileName", "uuid", "immich_current", "apple_correct", "delta_days"]
    with open(args.plan, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(plan)

    print(f"\nScanned assets:       {seen}", file=sys.stderr)
    print(f"Matched Apple UUIDs:  {matched}", file=sys.stderr)
    print(f"Need correction:      {len(plan)}  (>{args.diff_days}d)", file=sys.stderr)
    print(f"Plan written:         {args.plan}", file=sys.stderr)

    if not plan:
        print("\nNothing to fix -- all dates already match Apple Photos.", file=sys.stderr)
        return

    if not args.apply:
        print("\nDRY RUN -- nothing changed. Re-run with --apply to write.", file=sys.stderr)
        for r in plan[:10]:
            print(f"  {r['uuid']}  {r['immich_current']}  ->  {r['apple_correct']}  ({r['originalFileName']})",
                  file=sys.stderr)
        if len(plan) > 10:
            print(f"  ... and {len(plan) - 10} more (see {args.plan})", file=sys.stderr)
        return

    todo = plan[: args.limit] if args.limit else plan
    ok = err = 0
    for i, r in enumerate(todo, 1):
        try:
            api.request("PUT", f"/assets/{r['id']}", {"dateTimeOriginal": r["apple_correct"]})
            ok += 1
        except Exception as e:  # noqa: BLE001 -- report and continue
            err += 1
            print(f"  ERR {r['uuid']}: {e}", file=sys.stderr)
        if i % 100 == 0:
            print(f"  ...{i}/{len(todo)} (ok={ok} err={err})", file=sys.stderr)
    print(f"\nApplied: ok={ok} err={err} of {len(todo)}", file=sys.stderr)


if __name__ == "__main__":
    main()
