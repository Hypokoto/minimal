# Empirical Runtime Qualification Report

## Executive Summary
This document records the empirical results of the **Runtime Qualification Phase** for `minimal`. Static invariants (CI/ShellCheck/shfmt) are verified and green. All testing was executed on hardware against actual session state.

---

## Qualification Matrix

| Qualification Test | Expected Result | Actual Empirical Result | Status |
|---|---|---|---|
| **1. Listening Socket Audit** | No unknown open external ports | Ports: 22 (SSH), 631 (CUPS loopback only), AGY/Ollama IPC. Documented in `socket_justifications.md`. | **PASS** |
| **2. Notification Lifecycle (Mako)** | 0 failed user units; Mako active | Finding #001 caught syntax error + duplicate autostart. Fixed in `colors.lua` & `hyprland.lua`. 0 failed units. | **PASS** |
| **3. Process Budget Compliance** | Authorized core daemons only; 0 uncategorized daemons | Budget intact. Authorized: `Hyprland`, `waybar`, `mako`, `hypridle`, `awww-daemon`, `polkit-gnome`, `wl-paste` (x3), `swayosd-server`. | **PASS** |
| **4. Deployment Idempotency** | Sequential `./deploy.sh` runs produce 0 duplicate symlinks or services | 100% of symlinks reported `Link intact` on rerun. Systemd units enabled cleanly once. | **PASS** |
| **5. Installer Safety (`--dry-run`)** | Zero filesystem, package, or service mutations | `./install.sh --dry-run` performs 0 side effects, leaves no state files in `~/.local/state`. | **PASS** |
| **6. AUR Trust Boundary** | Default `./install.sh` installs 0 AUR packages and does NOT bootstrap `yay` | Tested. `yay` bootstrap occurs ONLY when `--with-aur` is explicitly requested. | **PASS** |

---

## Detailed Findings & Resolutions

### Finding #001: Notification Daemon (`mako`) Systemd Unit Collision & Config Syntax Error
- **Symptom**: `systemctl --user --failed` reported `mako.service` in `failed` state.
- **Root Cause**: Twofold:
  1. `hypr/colors.lua` compiled `mako/config` with space-separated `padding=14 16` instead of `padding=14,16`.
  2. `hyprland.lua` contained an autostart hook `hl.exec_cmd("mako")`, colliding with systemd/D-Bus unit activation.
- **Resolution**: Fixed `padding=14,16` generator in `colors.lua` and removed duplicate `hl.exec_cmd("mako")`.
- **Verification**: `systemctl --user restart mako.service` succeeded. `systemctl --user --failed` returns `0 loaded units listed`.

---

## Listening Socket Audit Summary (`runtime/baseline/socket_justifications.md`)

- `127.0.0.1:631` / `[::1]:631` (`cupsd`): Local print scheduler. Bound strictly to `localhost` (loopback). Zero external exposure.
- `0.0.0.0:22` / `[::]:22` (`sshd`): Remote SSH administration. Protected by `nftables` DROP policy.
- `127.0.0.1:35335, 35799` (`agy`): Local CLI IPC sockets. Bound strictly to `localhost`.
- `127.0.0.1:11434` (`ollama`): Local LLM API endpoint. Bound strictly to `localhost`.

---

## Verification Statement
The Minimal OS Shell architecture has successfully passed all defined security and runtime qualification invariants. All background processes adhere to `PROCESS_BUDGET.md`, supply-chain boundaries are machine-enforced, generated configuration syntaxes are validated, and all systemd user units operate in a healthy, zero-failure state.
