#!/usr/bin/env bash
# ==============================================================================
# resize.sh — Dynamic Window Resizing Helper for Hyprland 0.55+
# Usage:
#   resize.sh left   # Shrink width by 50px
#   resize.sh right  # Expand width by 50px
#   resize.sh up     # Shrink height by 50px
#   resize.sh down   # Expand height by 50px
# ==============================================================================
set -euo pipefail

DIRECTION="${1:-right}"
STEP=50
MIN_W=300
MIN_H=200

ACTIVE_WIN=$(hyprctl -j activewindow 2>/dev/null || true)

if [ -z "$ACTIVE_WIN" ] || [ "$ACTIVE_WIN" = "null" ]; then
	exit 0
fi

CUR_W=$(echo "$ACTIVE_WIN" | jq -r '.size[0] // 800')
CUR_H=$(echo "$ACTIVE_WIN" | jq -r '.size[1] // 600')

NEW_W=$CUR_W
NEW_H=$CUR_H

case "$DIRECTION" in
left)
	NEW_W=$((CUR_W - STEP))
	[ "$NEW_W" -lt "$MIN_W" ] && NEW_W=$MIN_W
	;;
right)
	NEW_W=$((CUR_W + STEP))
	;;
up)
	NEW_H=$((CUR_H - STEP))
	[ "$NEW_H" -lt "$MIN_H" ] && NEW_H=$MIN_H
	;;
down)
	NEW_H=$((CUR_H + STEP))
	;;
*)
	echo "Usage: $0 {left|right|up|down}"
	exit 1
	;;
esac

hyprctl dispatch "hl.dsp.window.resize({ x = ${NEW_W}, y = ${NEW_H} })" >/dev/null 2>&1 || true
