#!/usr/bin/env bash
# Minimal — Waybar Lifecycle Manager
# Starts Waybar, hides it initially, and configures the Focus mode gaps.
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
