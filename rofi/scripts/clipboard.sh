#!/usr/bin/env bash
# ==============================================================================
# Minimal Rofi Clipboard Suite
# Interfaced with cliphist + wl-clipboard
# ==============================================================================
set -euo pipefail
pkill -x rofi || true

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v cliphist >/dev/null 2>&1; then
    notify-send -u critical "Clipboard Manager" "cliphist binary not found in PATH"
    exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
    notify-send -u critical "Clipboard Manager" "wl-clipboard (wl-copy) binary not found in PATH"
    exit 1
fi

THEME_PATH="${DIR}/clipboard.rasi"
ROFI_CMD=(rofi -dmenu -p "Clipboard" -mesg "Enter: Copy | Alt+Delete: Delete entry" -kb-custom-1 "Alt+Delete" -format "s")

if [[ -f "${THEME_PATH}" ]]; then
    ROFI_CMD+=(-theme "${THEME_PATH}")
fi

set +e
SELECTION="$(cliphist list | "${ROFI_CMD[@]}")"
STATUS=$?
set -e

# Exit code 10 corresponds to custom keybind -kb-custom-1 (Alt+Delete)
if [[ ${STATUS} -eq 10 ]]; then
    if [[ -n "${SELECTION}" ]]; then
        cliphist delete <<< "${SELECTION}"
        notify-send -a "minimal" "Clipboard Manager" "Entry deleted"
    fi
    exit 0
fi

if [[ -n "${SELECTION}" ]]; then
    cliphist decode <<< "${SELECTION}" | wl-copy
    notify-send -a "minimal" "Clipboard Manager" "Copied to clipboard"
fi
