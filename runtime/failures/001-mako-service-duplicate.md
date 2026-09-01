# Runtime Qualification Finding #001

- **Component**: Notification Daemon (`mako`)
- **Reproduction**: Run `systemctl --user --failed` in active session.
- **Expected**: 0 failed user systemd units.
- **Actual**: `mako.service` marked as `failed`.
- **Severity**: Low / Reliability Hygiene.
- **Root Cause**: Twofold:
  1. Config syntax error: `hypr/colors.lua` compiled `mako/config` with `padding=14 16` (space-separated) instead of `padding=14,16` (comma-separated), causing `mako` to fail config parsing on boot.
  2. Double activation: `hyprland.lua` autostart contained redundant `hl.exec_cmd("mako")` alongside `mako.service`.
- **Fix Applied**:
  1. Fixed `padding=14,16` in `hypr/colors.lua` generator and recompiled targets.
  2. Removed `hl.exec_cmd("mako")` from `hyprland.lua` to let systemd user service manage `mako` exclusively.
- **Verification Result**: `systemctl --user reset-failed mako.service && systemctl --user restart mako.service` succeeds cleanly. `systemctl --user --failed` reports 0 failed units.
