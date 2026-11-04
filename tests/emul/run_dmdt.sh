#!/bin/sh
# Fork: run the unit's own dmdt binary under the QNX 6.5 user-mode runtime.
#
# Two ways to load QNX binaries on Linux host:
#  (1) USE_LUKA=1 — point at the luka-dev/qnx65-armv7-toolchain repo that has
#     built a QNX 6.5 "ldqnx.so.2" loader and QNX libs; the scripts then
#     resolve them via that tree. Recommended path.
#  (2) fallback: qemu-arm-static direct — needs a working QNX interpreter on
#     the host binfmt/i före-LD path; without that, "Exec format error" is
#     the expected result (see README, FAQ below).
ROOT="`dirname "$0"`/root"
LOAD_ARGUMENTS="$*"
: "${DMDT_ARGS:=$LOAD_ARGUMENTS}"
if [ -z "$DMDT_ARGS" ]; then DMDT_ARGS="-gs"; fi
QTNXDIR="${QNX_TOOLCHAIN_DIR:-../qnx65-armv7-toolchain}"
QNXINTERP="$QTNXDIR/host-runtime/usr/lib/ldqnx.so.2"
if [ ! -x "$QNXINTERP" ]; then QNXINTERP=""; fi
LD_LIBRARY_PATH="$ROOT/lib:$ROOT/armle/lib:$ROOT/armle/usr/lib:$ROOT/lib/dll:$ROOT/eso/lib":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
if [ -n "$QNXINTERP" ]; then
    QNXM="${QNX_ROOT:-$QTNXDIR/host-runtime}"
    QNX_RESOLVER="-- $QNXINTERP"
    QEMU_LD_PREFIX="$QNXM"
else
    QNX_RESOLVER=""
    QEMU_LD_PREFIX="$ROOT"
fi
qemu-arm-static $QNX_RESOLVER "$ROOT/eso/bin/apps/dmdt" $DMDT_ARGS 2>&1
