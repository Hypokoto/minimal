#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MODES="All:${DIR}/scripts/rofi-apps.py All,Web:${DIR}/scripts/rofi-apps.py Web Browsers,Dev:${DIR}/scripts/rofi-apps.py Development,Chat:${DIR}/scripts/rofi-apps.py Communication,Art:${DIR}/scripts/rofi-apps.py Graphics,Office:${DIR}/scripts/rofi-apps.py Office,Media:${DIR}/scripts/rofi-apps.py Multimedia,System:${DIR}/scripts/rofi-apps.py System,Utils:${DIR}/scripts/rofi-apps.py Utilities,Games:${DIR}/scripts/rofi-apps.py Games,Misc:${DIR}/scripts/rofi-apps.py Other"

rofi -pid /tmp/rofi-launcher.pid \
    -modi "$MODES" \
    -show All \
    -theme "${DIR}/launcher.rasi"
