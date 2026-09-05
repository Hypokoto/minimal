#!/usr/bin/env bash
# Minimal — Event-driven Battery Monitor
# Managed by systemd --user. Triggers Waybar reveal on low battery.
set -euo pipefail

# Fail closed if upower is missing
if ! command -v upower >/dev/null 2>&1; then
	echo "upower not found. Exiting."
	exit 0
fi

STATE_FILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/minimal-battery-low"
TOGGLE_SCRIPT="${HOME}/.config/hypr/scripts/toggle-bar.sh"

# Single awk parsing for efficiency and robustness
upower -m | awk '/percentage:/ {print $2+0}' | while read -r level; do
	if [ -z "$level" ]; then continue; fi

	if [ "$level" -le 20 ] && [ ! -f "$STATE_FILE" ]; then
		touch "$STATE_FILE"
		"$TOGGLE_SCRIPT" --show 2>/dev/null || true
		notify-send -u critical -i battery-caution "Low Battery (${level}%)" "Waybar revealed." 2>/dev/null || true
	elif [ "$level" -gt 20 ] && [ -f "$STATE_FILE" ]; then
		rm -f "$STATE_FILE"
	fi
done
