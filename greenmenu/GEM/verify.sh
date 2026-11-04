#!/bin/sh
# Fork addition: verify the installed files against the checksum manifest the
# installer left on the unit. Recomputes CRC (cksum) for every line the
# installer recorded and reports PASS / CHANGED per file, so an owner whose
# panel behaves oddly can distinguish a broken install from a settings issue
# without pulling the SD card or reading the hook log.
. "`dirname "$0"`/common.sh"
MANIFEST=/mnt/app/eso/lib/gal_dualscreen/verify_manifest.txt
echo "Phone map on the digital cluster: verify installed files"
if [ ! -r "$MANIFEST" ]; then
    echo "No checksum manifest found at $MANIFEST"
    echo "(this unit was last installed by a version before the verify script, or"
    echo "the manifest was removed; reinstall from the SD card to recreate it)"
    exit 0
fi
if command -v cksum >/dev/null 2>&1; then
    TOOL=cksum
else
    echo "No checksum command on this unit (cksum missing); cannot verify."
    exit 0
fi
FAIL=0; TOTAL=0
while read -r tag file want; do
    [ -r "$file" ] || { echo "CHANGED  $file (missing)"; FAIL=$((FAIL+1)); TOTAL=$((TOTAL+1)); continue; }
    f=`cksum "$file" | awk '{print $1, $2}'`
    case "$f" in $want) echo "PASS     $file" ;;
                *) echo "CHANGED  $file (cksum $f, manifest $want)"; FAIL=$((FAIL+1)); TOTAL=$((TOTAL+1)); continue; ;; esac
    TOTAL=$((TOTAL+1))
done < "$MANIFEST"
echo
if [ "$FAIL" = 0 ]; then
    echo "All $TOTAL installed files match the manifest."
else
    echo "$FAIL of $TOTAL installed files changed since the install."
    echo "Re-run the update on the SD card to reinstall them, or have a look at"
    echo "docs/Install.md; if the mismatch survives that, post the update_result."
fi
exit 0
