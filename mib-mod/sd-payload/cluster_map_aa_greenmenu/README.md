# cluster_map_aa_greenmenu — M.I.B. mod payload

## What goes on the SD card (M.I.B. convention)

This is the **fork's own per-MU payload**, packaged as an M.I.B. "mod" so
it can be driven from M.I.B.'s GEM screens (see
[`mib-mod/esd/Launcher-sda0.esd.append.md`](../../esd/Launcher-sda0.esd.append.md))
in addition to the upstream metainfo2 SD-card update. Everything under
`mod/cluster_map_aa_greenmenu/` on the M.I.B.-SD card (`/net/mmx/fs/sda0/…`)
follows the same folder tree that M.I.B. uses for its own mods:
**paths below are relative to the M.I.B. SD card root** (`/net/mmx/fs/sda0/`).

| Path | What it does | Ships in git? |
|---|---|---|
| `scripts/enable_hook.sh` | installs the AA→VC hook | ✅ |
| `scripts/disable_hook.sh` | uninstall | ✅ |
| `scripts/hook_status.sh` | status | ✅ |
| `scripts/collect_logs.sh` | log collection | ✅ |
| `scripts/lib_*.sh`, `scripts/lsd_jar.sh` | shared helpers | ✅ |
| `scripts/full_frame_on.sh` / `full_frame_off.sh` / `window_fix.sh` / `turn_by_turn.sh` | GEM switch helpers | ✅ |
| `scripts/gal_dualscreen.default.conf` | default `gal_dualscreen.conf` (upstream) | ✅ |
| `scripts/experiments/zoom_test.sh` | zoom diagnostic harness | ✅ |
| `config/profiles.conf` | per-train profile table (fork's own, from upstream) | ✅ |
| `config/framework.json` | the IFS file the fork's arbiter dmdt probe reads | ✅ (from the *stock* unit tree) |
| `thirdparty/NavActiveIgnore.jar` | already in the M.I.B./jilleb toolbox as well; the fork carries its own copy | ✅ (MIT per upstream) |
| `thirdparty/VCAndroidAuto.jar` | the fork's maintained turn-arrows jar (our fork of adi961) | ✅ (MIT per upstream) |
| `greenmenu/*.sh` | the fork's own GEM screens (have a look; can be added side-by-side with M.I.B.'s GEM) | ✅ |
| `greenmenu/cluster-map.esd` | the fork's own GEM top-level screen (reference) | ✅ |
| `binaries/libgal_hook.so` | **per-MU build, not in git** | ❌ (build from upstream's `build_local.sh`) |
| `binaries/stream-player` | **per-MU build** | ❌ |
| `binaries/libdmdt_flush.so` | per-MU build | ❌ |
| `binaries/dmdtgo.c` / `binaries/rundmdt` | AA-zoom helper (source) | ✅ |

Binaries are built per unit (`tools/find_profile.py` on the unit's own
`gal`), so they never live in git. Drop the built ones into
`binaries/` yourself or grab the per-MU release from the upstream
`MHI2_ER_VWG13_P4521[_1]` / `K4525` release pages and verify the SHA-256.

## What does NOT ship here

- **`libcarplay_cluster.so`** — that is M.I.B.'s bundled CarPlay Maps VC
  payload (`mod/carplay_maps_vc/omonob/`), which has its own supervisor,
  jar and scripts. Do NOT install our fork's CarPlay GEM screen alongside
  M.I.B.'s CarPlay payload — they write to the same unit paths
  (`carplaymaps/`, `CarPlayClusterControls*.jar`, `altscreen-most-bridge`)
  and collide.

## How the M.I.B. GEM screen knows where this lives

`mib-mod/esd/Launcher-sda0.esd.append.md` defines 4 screens that call:

```
/net/mmx/fs/sda0/mod/cluster_map_aa_greenmenu/scripts/{status,install,uninstall,collect}
```

…which is exactly this folder when the mod is dropped on an M.I.B. SD card,
copied verbatim. M.I.B.'s `GEM=1` is left set, and the fork's own scripts
(defensively unset it) as they'd run from the car's SD card.

## Copy instructions (M.I.B.'s own "mod" convention)

1. Download the fork's release bundle (`ClusterMap` + per-MU release) and
   unpack it to this folder — scripts are read straight off the SD.
2. Also add `-prerequisites` on the unit: `NavActiveIgnore.jar` (M.I.B.'s
   toolbox can install it for you, or our fork's own installer adds it).
3. Make sure that M.I.B.'s launcher (Launcher-sda0.esd) has the 4 new
   screens wired in, per `mib-mod/esd/Launcher-sda0.esd.append.md`.

Then boot into M.I.B. GEM, and the screens appear live.

## Prerequisite — M.I.B. itself must already be installed

(MHI2/MHI2Q, GEM ≥ 4.1; older GEM auto-upgrades to 4.12 during M.I.B.
install.) M.I.B. is the base toolbox — our fork's GEM entry nests under
M.I.B.'s ecosystem at the GEM top-level. Do not try to install our fork
in a car that doesn't have M.I.B.: use upstream mib-cluster-map's
**own** metainfo2 SD-card install instead (equivalent result, no M.I.B.
dependency).
