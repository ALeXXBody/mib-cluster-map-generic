#!/bin/sh
# Fork: run the unit's own gal binary under qemu-arm usermode (experiment),
# with the hook injected via LD_PRELOAD if it is also in the root.
ROOT="`dirname "$0"`/root"
EXTRA=""
[ -r "$ROOT/eso/lib/gal_dualscreen/libgal_hook.so" ] && \
    EXTRA="LD_PRELOAD=$ROOT/eso/lib/gal_dualscreen/libgal_hook.so"
LD_LIBRARY_PATH="$ROOT/lib:$ROOT/armle/lib:$ROOT/armle/usr/lib:$ROOT/lib/dll:$ROOT/eso/lib" \
QEMU_LD_PREFIX="$ROOT" \
    env $EXTRA qemu-arm-static -- "$ROOT/eso/bin/apps/gal" "$@" 2>&1
