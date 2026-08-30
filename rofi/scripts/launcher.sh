#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

MODES=$("${DIR}/scripts/rofi-apps.py" get_modes)

rofi -pid /tmp/rofi-launcher.pid \
    -modi "$MODES" \
    -show All \
    -theme "${DIR}/launcher.rasi"
