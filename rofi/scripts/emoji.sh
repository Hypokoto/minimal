#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# rofimoji's "copy" action already pushes the selection to the clipboard
# via wl-copy (Wayland) or xclip (X11). We just confirm what landed there.
rofimoji \
    --action copy \
    --selector-args="-pid /tmp/rofi-emoji.pid -p '󰞅  Emoji' -theme ${DIR}/emoji.rasi"

# Give the clipboard a beat to settle before reading it back.
sleep 0.05

if command -v wl-paste >/dev/null 2>&1; then
    PICKED="$(wl-paste 2>/dev/null || true)"
elif command -v xclip >/dev/null 2>&1; then
    PICKED="$(xclip -selection clipboard -o 2>/dev/null || true)"
else
    PICKED=""
fi

if [[ -n "${PICKED}" ]]; then
    notify-send "Emoji copied" "${PICKED}"
fi
