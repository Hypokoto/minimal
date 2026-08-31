#!/usr/bin/env bash
# ==============================================================================
# Minimal Rofi Display Manager
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Identify internal and external monitors
INTERNAL=$(hyprctl monitors all -j | jq -r '.[] | select(.name | startswith("eDP")) | .name' | head -n 1)
if [[ -z "$INTERNAL" ]]; then
    INTERNAL="eDP-1" # fallback
fi

EXTERNAL=$(hyprctl monitors all -j | jq -r '.[] | select(.name != "'$INTERNAL'") | .name' | head -n 1)

if [[ -z "$EXTERNAL" ]]; then
    EXTERNAL="DP-1" # Fallback so the UI at least works for testing
fi

OPTIONS=$'PC Only\nDuplicate\nExtended\nExternal Only'

THEME_PATH="${DIR}/powermenu.rasi"
ROFI_CMD=(rofi -dmenu -pid /tmp/rofi-display.pid -p "Display" -u "0" -a "1" -me-select-entry '' -me-accept-entry MousePrimary)

if [[ -f "${THEME_PATH}" ]]; then
    ROFI_CMD+=(-theme "${THEME_PATH}" -theme-str 'listview { columns: 4; } window { width: 600px; }')
fi

set +e
CHOICE="$(echo -n "${OPTIONS}" | "${ROFI_CMD[@]}")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

case "${CHOICE}" in
    "PC Only")
        hyprctl eval "hl.monitor({ output = '$INTERNAL', mode = 'preferred', position = 'auto', scale = '1' })"
        hyprctl eval "hl.monitor({ output = '$EXTERNAL', disabled = true })"
        notify-send "Display" "Switched to PC Only" || true
        ;;
    "Duplicate")
        hyprctl eval "hl.monitor({ output = '$INTERNAL', mode = 'preferred', position = 'auto', scale = '1' })"
        hyprctl eval "hl.monitor({ output = '$EXTERNAL', mode = 'preferred', position = 'auto', scale = '1', mirror = '$INTERNAL' })"
        notify-send "Display" "Switched to Duplicate" || true
        ;;
    "Extended")
        hyprctl eval "hl.monitor({ output = '$INTERNAL', mode = 'preferred', position = 'auto', scale = '1' })"
        hyprctl eval "hl.monitor({ output = '$EXTERNAL', mode = 'preferred', position = 'auto', scale = '1' })"
        notify-send "Display" "Switched to Extended" || true
        ;;
    "External Only")
        hyprctl eval "hl.monitor({ output = '$EXTERNAL', mode = 'preferred', position = 'auto', scale = '1' })"
        hyprctl eval "hl.monitor({ output = '$INTERNAL', disabled = true })"
        notify-send "Display" "Switched to External Only" || true
        ;;
    *)
        exit 0
        ;;
esac
