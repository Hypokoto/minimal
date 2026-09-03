#!/usr/bin/env bash
# ==============================================================================
# snap.sh — Precision Spatial Window Snapping & Tiling Helper for Hyprland
#
# Provides tmux-style automatic window layout adjustment without overlapping:
#   left         — Snap/move window left half / tile left
#   right        — Snap/move window right half / tile right
#   top          — Snap/move window top half / tile up
#   bottom       — Snap/move window bottom half / tile down
#   top-left     — Snap top-left quarter
#   top-right    — Snap top-right quarter
#   bottom-left  — Snap bottom-left quarter
#   bottom-right — Snap bottom-right quarter
#   center       — Center window (70% width, 70% height)
# ==============================================================================
set -euo pipefail

POSITION="${1:-center}"

WINDOW_COUNT=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.windows // 0')

# For multi-window tiling workspaces, directional snap moves tiled windows cleanly like tmux panes
if [ "$WINDOW_COUNT" -gt 1 ]; then
    case "$POSITION" in
        left)
            hyprctl dispatch 'hl.dsp.window.float({ action = "off" })' >/dev/null 2>&1 || true
            hyprctl dispatch 'hl.dsp.window.move({ direction = "l" })' >/dev/null 2>&1 || true
            exit 0
            ;;
        right)
            hyprctl dispatch 'hl.dsp.window.float({ action = "off" })' >/dev/null 2>&1 || true
            hyprctl dispatch 'hl.dsp.window.move({ direction = "r" })' >/dev/null 2>&1 || true
            exit 0
            ;;
        top)
            hyprctl dispatch 'hl.dsp.window.float({ action = "off" })' >/dev/null 2>&1 || true
            hyprctl dispatch 'hl.dsp.window.move({ direction = "u" })' >/dev/null 2>&1 || true
            exit 0
            ;;
        bottom)
            hyprctl dispatch 'hl.dsp.window.float({ action = "off" })' >/dev/null 2>&1 || true
            hyprctl dispatch 'hl.dsp.window.move({ direction = "d" })' >/dev/null 2>&1 || true
            exit 0
            ;;
    esac
fi

# Single window or explicit quarter/center snap: compute pixel-perfect non-overlapping geometry
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
