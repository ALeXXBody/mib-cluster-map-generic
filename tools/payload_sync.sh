#!/bin/sh
# payload_sync.sh — keeps the fork's sd-payload and the Addon's shipped
# payload identical. Two copies of one tree in two repositories is a drift
# risk; this script is the check and, with --apply, the fix.
#
#   tools/payload_sync.sh <path-to-MIB-Addon-Cluster-AA-CP>          # check
#   tools/payload_sync.sh <path-to-MIB-Addon-Cluster-AA-CP> --apply  # sync
#
# The Addon's payload is the shipping one (what cards actually receive), so
# this script copies FROM the Addon repo INTO mib-mod/sd-payload/... of this
# repository and reports any drift first.
set -eu
HERE=`dirname "$0"`
REPO=`cd "$HERE/.." && pwd`

ADDON_DIR=${1:-}
if [ -z "${ADDON_DIR:-}" ] || [ ! -d "$ADDON_DIR/mod/cluster_map_aa_greenmenu" ]; then
    echo "usage: $0 <path-to-MIB-Addon-Cluster-AA-CP-repo> [--apply]" >&2
    echo "The repo must contain mod/cluster_map_aa_greenmenu/ (its payload)." >&2
    exit 2
fi
case "${2:-}" in --apply) APPLY=1 ;; *) APPLY=0 ;; esac

SRC="$ADDON_DIR/mod/cluster_map_aa_greenmenu"
DST="$REPO/mib-mod/sd-payload/cluster_map_aa_greenmenu"

# The two files that only make sense in their own home (the Addon's owner
# docs) are excluded; everything else in the payload directory must match.
echo "checking payload drift:"
echo "  src = $SRC"
echo "  dst = $DST"
echo "(differences below are the drift; --apply copies the Addon's files over)"

TMPD=`mktemp -d`
trap 'rm -rf "$TMPD"' EXIT
(cd "$SRC" && find . -type f \( -name '*.sh' -o -name '*.esd' -o -name '*.conf' \
    -o -name '*.so' -o -name 'stream-player' -o -name 'profile_check' -o -name '*.jar' \) \
    | LC_ALL=C sort | xargs -d'\n' sha256sum) > "$TMPD/src.sha"
(cd "$DST" && find . -type f \( -name '*.sh' -o -name '*.esd' -o -name '*.conf' \
    -o -name '*.so' -o -name 'stream-player' -o -name 'profile_check' -o -name '*.jar' \) \
    | LC_ALL=C sort | xargs -d'\n' sha256sum) > "$TMPD/dst.sha"

if diff -u "$TMPD/dst.sha" "$TMPD/src.sha" | head -40 > "$TMPD/diff"; then
    echo "payload_sync: OK, no drift."
    exit 0
fi
cat "$TMPD/diff"
if [ "$APPLY" = 1 ]; then
    echo "applying: copying the Addon's payload over this repo's copy..."
    find "$DST" -maxdepth 2 -type f -name 'SHA256SUMS.txt' -delete 2>/dev/null || true
    (cd "$SRC" && tar cf - .) | (cd "$DST" && tar xf -)
    echo "payload_sync: applied. Review and commit the mib-mod/ changes."
else
    echo "payload_sync: DRIFT DETECTED. run with --apply to sync from the Addon repo, then commit."
    exit 1
fi
