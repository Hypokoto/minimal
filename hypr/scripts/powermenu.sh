#!/usr/bin/env bash
# Aetheria — Power Menu script wrapper delegating to Rofi powermenu suite
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROFI_POWERMENU="${HOME}/.config/rofi/scripts/powermenu.sh"
REPO_POWERMENU="${SCRIPT_DIR}/../../rofi/scripts/powermenu.sh"

if [[ -f "${ROFI_POWERMENU}" ]]; then
    exec bash "${ROFI_POWERMENU}"
elif [[ -f "${REPO_POWERMENU}" ]]; then
    exec bash "${REPO_POWERMENU}"
else
    echo "Error: Rofi powermenu script not found." >&2
    exit 1
fi
