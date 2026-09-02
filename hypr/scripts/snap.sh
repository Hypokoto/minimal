#!/usr/bin/env bash
# ==============================================================================
# snap.sh — Spatial Window Snapping Helper for Hyprland
#
# Provides deterministic Windows-style spatial snapping for floating and tiled windows:
#   left         — Snap to left 50% half
#   right        — Snap to right 50% half
#   top          — Snap to top 50% half
#   bottom       — Snap to bottom 50% half
#   top-left     — Snap to top-left quarter
#   top-right    — Snap to top-right quarter
#   bottom-left  — Snap to bottom-left quarter
#   bottom-right — Snap to bottom-right quarter
#   center       — Center window (65% width, 65% height)
# ==============================================================================
set -euo pipefail

POSITION="${1:-center}"

case "$POSITION" in
    left)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 100% 2>/dev/null || true
        hyprctl dispatch moveactive exact 0 0 2>/dev/null || true
        ;;
    right)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 100% 2>/dev/null || true
        hyprctl dispatch moveactive exact 50% 0 2>/dev/null || true
        ;;
    top)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 100% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 0 0 2>/dev/null || true
        ;;
    bottom)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 100% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 0 50% 2>/dev/null || true
        ;;
    top-left)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 0 0 2>/dev/null || true
        ;;
    top-right)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 50% 0 2>/dev/null || true
        ;;
    bottom-left)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 0 50% 2>/dev/null || true
        ;;
    bottom-right)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 50% 50% 2>/dev/null || true
        hyprctl dispatch moveactive exact 50% 50% 2>/dev/null || true
        ;;
    center)
        hyprctl dispatch setfloating active 2>/dev/null || true
        hyprctl dispatch resizeactive exact 65% 65% 2>/dev/null || true
        hyprctl dispatch centerwindow 2>/dev/null || true
        ;;
    *)
        echo "Usage: $0 {left|right|top|bottom|top-left|top-right|bottom-left|bottom-right|center}"
        exit 1
        ;;
esac
