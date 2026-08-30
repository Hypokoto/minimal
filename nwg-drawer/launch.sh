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

# -c 5      : 5 columns of apps
# -is 48    : icon size 48px
# -spacing  : 16px gap between icons
# -fm       : file manager command for directories
# -term     : terminal emulator
exec nwg-drawer -c 5 -is 48 -spacing 16 -term "kitty" -fm "kitty -e yazi"
