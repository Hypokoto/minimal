#!/usr/bin/env bash
# ==============================================================================
# toggle-bar.sh — Focus / Bento Mode Toggle (Quickshell Integration)
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

case "${1:-}" in
    --show)
        set_bento_mode
        touch "$STATE_FILE"
        ;;
    --hide)
        set_focus_mode
        rm -f "$STATE_FILE"
        ;;
    *)
        if [ -f "$STATE_FILE" ]; then
            set_focus_mode
            rm -f "$STATE_FILE"
        else
            set_bento_mode
            touch "$STATE_FILE"
        fi
        ;;
esac
