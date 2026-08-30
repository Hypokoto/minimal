#!/usr/bin/env bash
# ==============================================================================
# nwg-drawer Launcher — Categorized App Menu
# Toggle behavior: if running, kill it; if not, launch it.
# ==============================================================================
set -euo pipefail

if pgrep -x "nwg-drawer" > /dev/null; then
    pkill -x "nwg-drawer"
    exit 0
fi

# -c 6      : 6 columns of apps for wide bento grid
# -is 64    : Premium large 64px icon size
# -spacing  : 32px gap between icons
# -mt 54    : Top margin to prevent overlapping the floating Waybar pills
# -wm       : Explicitly use hyprland dispatcher
exec nwg-drawer -c 6 -is 64 -spacing 32 -mt 54 -wm hyprland -term "kitty" -fm "kitty -e yazi"
