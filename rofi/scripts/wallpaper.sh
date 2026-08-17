#!/usr/bin/env bash
# ==============================================================================
# Aetheria Rofi Wallpaper Switcher Bridge
# Bridges to hypr/wallpaper/picker.sh, hot-reloads via awww, re-injects palette
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PICKER_SCRIPT="${DOTFILES_DIR}/hypr/wallpaper/picker.sh"

if [[ -x "${PICKER_SCRIPT}" ]]; then
    exec "${PICKER_SCRIPT}" "$@"
elif [[ -f "${PICKER_SCRIPT}" ]]; then
    exec bash "${PICKER_SCRIPT}" "$@"
else
    notify-send -u critical "Wallpaper Picker" "Picker script not found at ${PICKER_SCRIPT}"
    exit 1
fi
