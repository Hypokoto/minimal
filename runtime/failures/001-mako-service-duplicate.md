# Runtime Qualification Finding #001

- **Component**: Notification Daemon (`mako`)
- **Reproduction**: Run `systemctl --user --failed` in active session.
- **Expected**: 0 failed user systemd units.
- **Actual**: `mako.service` is marked `failed`.
- **Severity**: Low / Reliability Hygiene.
- **Root Cause**: Double activation. `mako` is launched by `hyprland.lua` via `hl.exec_cmd("mako")`, while `mako.service` or D-Bus activation also attempts to start `mako`. The second instance exits with code 1.
- **Fix**: Remove `hl.exec_cmd("mako")` from `hyprland.lua` so systemd / D-Bus activation manages `mako.service` exclusively without collision.
- **Regression Test**: Run `notify-send "Test" "Hello"` and check `systemctl --user --failed` (must be 0).
