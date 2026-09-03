#!/usr/bin/env bash
# ==============================================================================
# snap.sh — Precision Spatial Window Snapping Helper for Hyprland
#
# Computes pixel-perfect snap coordinates respecting top bar height and gaps:
#   left         — Snap to left 50% half
#   right        — Snap to right 50% half
#   top          — Snap to top 50% half
#   bottom       — Snap to bottom 50% half
#   top-left     — Snap to top-left quarter
#   top-right    — Snap to top-right quarter
#   bottom-left  — Snap to bottom-left quarter
#   bottom-right — Snap to bottom-right quarter
#   center       — Center window (70% width, 70% height)
# ==============================================================================
set -euo pipefail

POSITION="${1:-center}"

# Query active monitor geometry
MONITOR_JSON=$(hyprctl -j monitors 2>/dev/null | jq -r '.[0] // empty' 2>/dev/null || true)

if [ -n "$MONITOR_JSON" ]; then
    MON_W=$(echo "$MONITOR_JSON" | jq -r '.width // 1920')
    MON_H=$(echo "$MONITOR_JSON" | jq -r '.height // 1080')
    MON_X=$(echo "$MONITOR_JSON" | jq -r '.x // 0')
    MON_Y=$(echo "$MONITOR_JSON" | jq -r '.y // 0')
else
    MON_W=1920
    MON_H=1080
    MON_X=0
    MON_Y=0
fi

BAR_HEIGHT=34
GAP_OUT=10
GAP_IN=6

# Calculate usable work area respecting bar & outer gaps
USABLE_X=$((MON_X + GAP_OUT))
USABLE_Y=$((MON_Y + BAR_HEIGHT + GAP_OUT))
USABLE_W=$((MON_W - (GAP_OUT * 2)))
USABLE_H=$((MON_H - BAR_HEIGHT - (GAP_OUT * 2)))

HALF_W=$(((USABLE_W - GAP_IN) / 2))
HALF_H=$(((USABLE_H - GAP_IN) / 2))

TARGET_X=$USABLE_X
TARGET_Y=$USABLE_Y
TARGET_W=$HALF_W
TARGET_H=$USABLE_H

case "$POSITION" in
    left)
        TARGET_X=$USABLE_X
        TARGET_Y=$USABLE_Y
        TARGET_W=$HALF_W
        TARGET_H=$USABLE_H
        ;;
    right)
        TARGET_X=$((USABLE_X + HALF_W + GAP_IN))
        TARGET_Y=$USABLE_Y
        TARGET_W=$HALF_W
        TARGET_H=$USABLE_H
        ;;
    top)
        TARGET_X=$USABLE_X
        TARGET_Y=$USABLE_Y
        TARGET_W=$USABLE_W
        TARGET_H=$HALF_H
        ;;
    bottom)
        TARGET_X=$USABLE_X
        TARGET_Y=$((USABLE_Y + HALF_H + GAP_IN))
        TARGET_W=$USABLE_W
        TARGET_H=$HALF_H
        ;;
    top-left)
        TARGET_X=$USABLE_X
        TARGET_Y=$USABLE_Y
        TARGET_W=$HALF_W
        TARGET_H=$HALF_H
        ;;
    top-right)
        TARGET_X=$((USABLE_X + HALF_W + GAP_IN))
        TARGET_Y=$USABLE_Y
        TARGET_W=$HALF_W
        TARGET_H=$HALF_H
        ;;
    bottom-left)
        TARGET_X=$USABLE_X
        TARGET_Y=$((USABLE_Y + HALF_H + GAP_IN))
        TARGET_W=$HALF_W
        TARGET_H=$HALF_H
        ;;
    bottom-right)
        TARGET_X=$((USABLE_X + HALF_W + GAP_IN))
        TARGET_Y=$((USABLE_Y + HALF_H + GAP_IN))
        TARGET_W=$HALF_W
        TARGET_H=$HALF_H
        ;;
    center)
        TARGET_W=$((USABLE_W * 70 / 100))
        TARGET_H=$((USABLE_H * 70 / 100))
        TARGET_X=$((USABLE_X + (USABLE_W - TARGET_W) / 2))
        TARGET_Y=$((USABLE_Y + (USABLE_H - TARGET_H) / 2))
        ;;
    *)
        echo "Usage: $0 {left|right|top|bottom|top-left|top-right|bottom-left|bottom-right|center}"
        exit 1
        ;;
esac

# Execute window float, resize, and move via Hyprland Lua dispatcher IPC
hyprctl dispatch 'hl.dsp.window.float({ action = "on" })' >/dev/null 2>&1 || true
hyprctl dispatch "hl.dsp.window.resize({ x = ${TARGET_W}, y = ${TARGET_H} })" >/dev/null 2>&1 || true
hyprctl dispatch "hl.dsp.window.move({ x = ${TARGET_X}, y = ${TARGET_Y} })" >/dev/null 2>&1 || true
