#!/usr/bin/env bash
# ==============================================================================
# gamemode.sh — Hyprland Performance Optimization Toggle
# Disables animations, blur, rounding, and shadows to maximize gaming performance
# ==============================================================================
set -euo pipefail

STATE_FILE="/tmp/hypr_gamemode.state"

if [ -f "$STATE_FILE" ]; then
    # Disable Game Mode -> Restore normal desktop animations and visual effects
    rm -f "$STATE_FILE"
    hyprctl reload >/dev/null 2>&1 || true
    notify-send -i joystick "Game Mode" "Deactivated — Animations and visual effects restored"
else
    # Enable Game Mode -> Disable animations, blur, rounding, and shadows for max FPS
    touch "$STATE_FILE"
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:rounding 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1" >/dev/null 2>&1 || true
    notify-send -i joystick "Game Mode" "Activated — Animations and visual effects disabled for max performance"
fi
