#!/usr/bin/env bash
# ==============================================================================
# Minimal Control Center
# Unified hub for DE actions
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS="${DIR}/scripts"

# Retrieve some current states for display
WIFI_SSID=$(iwgetid -r 2>/dev/null || echo "Disconnected")
BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "AC")

OPTIONS="󰖩  Network (${WIFI_SSID})
󰂯  Bluetooth
󰕾  Audio Output
󰥔  Calendar
󰤄  Do Not Disturb
󰏘  Wallpapers
󰍹  Displays
󰐥  Power Menu"

THEME_PATH="${DIR}/control-center.rasi"
ROFI_CMD=(rofi -dmenu -pid /tmp/rofi-control.pid -p "Control Center" -me-select-entry '' -me-accept-entry MousePrimary)

if [[ -f "${THEME_PATH}" ]]; then
    ROFI_CMD+=(-theme "${THEME_PATH}")
fi

set +e
CHOICE="$(echo "${OPTIONS}" | "${ROFI_CMD[@]}")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

case "${CHOICE}" in
    *"Network"*)     bash "${SCRIPTS}/network.sh" ;;
    *"Bluetooth"*)   bash "${SCRIPTS}/bluetooth.sh" ;;
    *"Audio"*)       bash "$HOME/.config/hypr/scripts/audio-toggle.sh" ;;
    *"Calendar"*)    bash "${SCRIPTS}/calendar.sh" ;;
    *"Do Not Disturb"*) makoctl mode -t dnd && notify-send "DND" "Toggled Do Not Disturb" ;;
    *"Wallpapers"*)  bash "$HOME/.config/hypr/wallpaper/picker.sh" ;;
    *"Displays"*)    hyprctl dispatch exec wdisplays || notify-send "Displays" "wdisplays not installed" ;;
    *"Power Menu"*)  bash "${SCRIPTS}/powermenu.sh" ;;
esac
