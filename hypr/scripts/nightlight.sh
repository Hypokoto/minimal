#!/usr/bin/env bash
# ==============================================================================
# nightlight.sh — Hyprland Compositor Night Light Shader Toggle
# Toggles hyprsunset (4500K warm color temperature) on/off with 0MB RAM overhead
# ==============================================================================
set -euo pipefail

if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset >/dev/null 2>&1 || true
    notify-send -i display-brightness "Night Light" "Deactivated — Normal color temperature restored"
else
    hyprsunset -t 4500 >/dev/null 2>&1 &
    notify-send -i display-brightness "Night Light" "Activated — Warm color temperature (4500K)"
fi
