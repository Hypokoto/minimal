#!/usr/bin/env bash
# ==============================================================================
# toggle-bar.sh — Atomic Waybar + Bento Grid Toggle
#
# Bar hidden  → no gaps, no rounding, no borders (windows fill edge to edge)
# Bar visible → bento gaps (in=6 out=10), rounding=10, 1px accent borders
#
# State is tracked via /tmp/bar-visible flag file.
# Low-battery auto-reveal also calls this script with --show.
# ==============================================================================
set -euo pipefail

STATE_FILE="/tmp/bar-visible"

# ---------------------------------------------------------------------------
# Hyprland gap / rounding helpers (uses hyprctl keyword — no reload needed)
# ---------------------------------------------------------------------------
apply_bento() {
    hyprctl keyword general:gaps_in      6
    hyprctl keyword general:gaps_out     10
    hyprctl keyword general:border_size  1
    hyprctl keyword decoration:rounding  10
    hyprctl keyword "general:col.active_border"   "rgba(00D9FFFF)"
    hyprctl keyword "general:col.inactive_border" "rgba(1C2230FF)"
}

apply_clean() {
    hyprctl keyword general:gaps_in      0
    hyprctl keyword general:gaps_out     0
    hyprctl keyword general:border_size  0
    hyprctl keyword decoration:rounding  0
}

# ---------------------------------------------------------------------------
# Waybar helper — toggle via SIGUSR1 (show via SIGUSR2 = guaranteed visible)
# ---------------------------------------------------------------------------
waybar_toggle() {
    local pid
    pid=$(pgrep -x waybar | head -n1 || true)
    [ -n "$pid" ] && kill -SIGUSR1 "$pid" 2>/dev/null || waybar &
}

waybar_show() {
    local pid
    pid=$(pgrep -x waybar | head -n1 || true)
    [ -n "$pid" ] && kill -SIGUSR2 "$pid" 2>/dev/null || waybar &
}

# ---------------------------------------------------------------------------
# Main logic
# ---------------------------------------------------------------------------
case "${1:-}" in
    --show)
        # Called by low-battery auto-reveal; force bar on + bento grid
        waybar_show
        apply_bento
        touch "$STATE_FILE"
        ;;
    --hide)
        # Programmatic hide; remove bento grid
        waybar_show   # SIGUSR2 = show; we then SIGUSR1 to hide (toggle off)
        sleep 0.05
        waybar_toggle
        apply_clean
        rm -f "$STATE_FILE"
        ;;
    *)
        # SUPER+B interactive toggle
        if [ -f "$STATE_FILE" ]; then
            # Currently visible → hide and remove bento grid
            waybar_toggle
            apply_clean
            rm -f "$STATE_FILE"
        else
            # Currently hidden → show and apply bento grid
            waybar_toggle
            apply_bento
            touch "$STATE_FILE"
        fi
        ;;
esac
