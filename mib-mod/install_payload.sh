#!/bin/sh

# Staging helper: copies the mib-cluster-map-tiguan fork payload into an
# M.I.B.-compatible *mod* folder on the SD card and appends the GEM screens
# to M.I.B.'s own launcher (safe on a fresh M.I.B. SD card).
#
# USAGE (from a PC/OSX/Linux terminal with the M.I.B. SD card mounted):
#    cp -r mib-mod /path/to/MIB-sd-card/mod/cluster_map_aa_greenmenu
#    # then on the *unit*, once M.I.B. is running, open the GEM and use the
#    # new "Cluster Map (Tiguan fork)" screens.
#
# Uploads from the fork:
#    scripts/lib_unit.sh, lib_app_mount.sh, lib_keep_settings.sh,
#    lib_cluster_frame.sh, lib_resolve_hook_log.sh, lsd_jar.sh
#       (helpers — used by the enable/disable/uninstall hooks)
#    scripts/enable_hook.sh		 the AA map installer (real fork code)
#    scripts/disable_hook.sh	 uninstall
#    scripts/hook_status.sh 	 status check
#    scripts/collect_logs.sh	 logs
#    scripts/full_frame_on.sh, full_frame_off.sh, window_fix.sh,
#    scripts/turn_by_turn.sh
#    scripts/gal_dualscreen.default.conf, profiles.conf, hashes.txt
#    libgal_hook.so			 compiled hook (this is the actual
#                       	 	 engine; built for your exact MU)
#    stream-player			 compiled player
#    NavActiveIgnore.jar, VCAndroidAuto.jar (only if you want the fork's own
#        Java patches; M.I.B.'s CarPlay maps install uses its own)
#    dmdtgo (optional)			 AA map zoom via M.I.B. GEM toggle
#    greenmenu/GEM/*.sh			 the fork's own GEM screens (have a
#                       	 	 look for reference, or add them side by
#                       	 	 side to M.I.B.'s GEM if you prefer)
#    gal_dualscreen.conf	 	 the fork's `auto` profile settings
#
# NOTE: these are NOT included here — you must compile them yourself or get
# them from the fork's release (per-MU builds for VWG13 P4521/K4525, same
# as upstream mib-cluster-map), because the binaries are not built from the
# public repo (they target the *unit's* own `gal` at a *specific* IFS offset,
# so each unit's own gal must be matched by `tools/find_profile.py`).
#
#   build instructions: see README of the upstream fork.
#
# GEM screens: they are automatically visible once the *M.I.B. launcher*
# Launcher-sda0.esd of M.I.B. is updated with the block from
# esd/Launcher-sda0.esd.append.md - add that block at the end of your SD
# card's Launcher-sda0.esd file to gain the 4 new menu screens.
#
# The screens:
#    cluster_map_aa_status
#    cluster_map_aa_installer
#    cluster_map_aa_uninstaller
#    cluster_map_aa_logs

echo "Use the copy routine from the fork's own printed `README` instead of this"
echo "helper — it just documents the paths. See README.md inside this folder."
echo ""
exit 0
