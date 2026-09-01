#!/usr/bin/env bash
# Event-driven Waybar Lifecycle & Battery Monitor
# Replaces the polling infinite loop with event-driven monitoring.
set -euo pipefail

# 1. Start Waybar
pkill -x waybar || true
waybar &
WAYBAR_PID=$!

# Wait for Waybar to initialize
sleep 1

# 2. Initial state: Focus mode (hidden, no gaps)
kill -SIGUSR1 "$WAYBAR_PID" 2>/dev/null || true
hyprctl keyword general:gaps_in 0 2>/dev/null || true
hyprctl keyword general:gaps_out 0 2>/dev/null || true
hyprctl keyword general:border_size 0 2>/dev/null || true
hyprctl keyword decoration:rounding 0 2>/dev/null || true

# 3. Event-driven battery monitoring (Zero idle CPU)
if command -v upower >/dev/null 2>&1; then
    upower -m | while read -r line; do
        if echo "$line" | grep -q "percentage:"; then
            level=$(echo "$line" | awk '{print $2}' | tr -d '%')
            if [ "$level" -le 20 ] && [ ! -f /tmp/.bat_low ]; then
                touch /tmp/.bat_low
                "$(dirname "${BASH_SOURCE[0]}")/toggle-bar.sh" --show 2>/dev/null || true
                notify-send -u critical -i battery-caution "Low Battery (${level}%)" "Waybar revealed." 2>/dev/null || true
            elif [ "$level" -gt 20 ] && [ -f /tmp/.bat_low ]; then
                rm -f /tmp/.bat_low
            fi
        fi
    done
else
    # If upower isn't available, just sleep forever so the script doesn't exit and zombie
    sleep infinity
fi
