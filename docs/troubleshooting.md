# Minimal OS Shell — Diagnostics & Troubleshooting

## 🩺 Diagnostic Tools

### 1. Diagnostic Doctor Suite (`minimalctl doctor`)
Runs security checks, process budget verification, systemd unit checks, theme drift validation, and package provenance verification.
```bash
minimalctl doctor
```

### 2. Configuration & Symlink Verification
Verifies directory layout, symlinks, and Hyprland keybinding syntax.
```bash
minimalctl config verify
```

### 3. Zero-Drift Theme Verification
Verifies that all 10 generated config targets accurately match the source TOML definitions.
```bash
minimalctl theme verify
```

---

## 🛠️ Common Resolutions

### Issue: Window floating offscreen or invisible
- **Solution**: Press **`SUPER + ALT + R`** to trigger `window-recover.sh`, which center-snaps the active floating window back onto the primary screen at 65% width/height.

### Issue: Red Hyprland configuration error banner
- **Solution**: Run `./deploy.sh` to redeploy clean symlinks and verify keybindings. Check `/tmp/minimal-deploy.log`.

### Issue: Keybindings not responding after editing
- **Solution**: Run `hyprctl reload` to reload the Hyprland compositor configuration live.
