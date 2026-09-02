#!/usr/bin/env bash
# ==============================================================================
# toggle-bar.sh — Focus / Bento Mode Toggle
#
# SUPER+B toggles between:
#   Focus mode  — Waybar hidden, gaps=0, border=0, rounding=0
#   Bento mode  — Waybar visible, gaps restored, border + rounding applied
#
# State tracked via /tmp/bar-visible flag file.
# ==============================================================================
set -euo pipefail

STATE_FILE="/tmp/bar-visible"

BENTO_GAPS_IN=6
BENTO_GAPS_OUT=10
BENTO_BORDER=1
BENTO_ROUNDING=12

set_bento_mode() {
    hyprctl keyword general:gaps_in "$BENTO_GAPS_IN" 2>/dev/null || true
    hyprctl keyword general:gaps_out "$BENTO_GAPS_OUT" 2>/dev/null || true
    hyprctl keyword general:border_size "$BENTO_BORDER" 2>/dev/null || true
    hyprctl keyword decoration:rounding "$BENTO_ROUNDING" 2>/dev/null || true
}

set_focus_mode() {
    hyprctl keyword general:gaps_in 0 2>/dev/null || true
    hyprctl keyword general:gaps_out 0 2>/dev/null || true
    hyprctl keyword general:border_size 0 2>/dev/null || true
    hyprctl keyword decoration:rounding 0 2>/dev/null || true
}

waybar_toggle() {
    local pid
    pid=$(pgrep -x waybar | head -n1 || true)
    if [ -n "$pid" ]; then
        kill -SIGUSR1 "$pid" 2>/dev/null
    else
        waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
    fi
}

waybar_show() {
    local pid
    pid=$(pgrep -x waybar | head -n1 || true)
    if [ -n "$pid" ]; then
        kill -SIGUSR2 "$pid" 2>/dev/null
    else
        waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css &
    fi
}

case "${1:-}" in
    --show)
        waybar_show
        set_bento_mode
        touch "$STATE_FILE"
        ;;
    --hide)
        waybar_show
        sleep 0.05
        waybar_toggle
        set_focus_mode
        rm -f "$STATE_FILE"
        ;;
    *)
        if [ -f "$STATE_FILE" ]; then
            waybar_toggle
            set_focus_mode
            rm -f "$STATE_FILE"
        else
            waybar_toggle
            set_bento_mode
            touch "$STATE_FILE"
        fi
        ;;
esac
