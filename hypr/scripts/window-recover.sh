#!/usr/bin/env bash
# ==============================================================================
# window-recover.sh — Emergency Universal Window Recovery Helper
#
# Bound to SUPER + ALT + R.
# Recovers lost, offscreen, hidden, or misplaced windows back to the active
# workspace, centered, floating, and sized to 65% x 65%.
# ==============================================================================
set -euo pipefail

ACTIVE_WS=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' || echo "1")

hyprctl dispatch movetoworkspace "$ACTIVE_WS" 2>/dev/null || true
hyprctl dispatch setfloating active 2>/dev/null || true
hyprctl dispatch resizeactive exact 65% 65% 2>/dev/null || true
hyprctl dispatch centerwindow 2>/dev/null || true
hyprctl dispatch focuswindow active 2>/dev/null || true

notify-send -a "Minimal" "Window Recovery" "Active window reset to current workspace (centered, floating)." 2>/dev/null || true
