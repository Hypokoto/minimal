#!/usr/bin/env bash
# ==============================================================================
# Minimal Rofi Bluetooth Manager
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_PATH="${DIR}/network.rasi"
ROFI_CMD=(rofi -dmenu -pid /tmp/rofi-bt.pid -p "Bluetooth" -me-select-entry '' -me-accept-entry MousePrimary)
[[ -f "${THEME_PATH}" ]] && ROFI_CMD+=(-theme "${THEME_PATH}")

POWER_STATE=$(bluetoothctl show | grep "Powered: yes" >/dev/null && echo "On" || echo "Off")

OPTIONS="[Toggle Power: ${POWER_STATE}]"
DEVICES=$(bluetoothctl devices | cut -d' ' -f2-)
[[ -n "$DEVICES" ]] && OPTIONS+=$'\n'"${DEVICES}"

set +e
CHOICE=$(echo "${OPTIONS}" | "${ROFI_CMD[@]}")
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

if [[ "${CHOICE}" == *"[Toggle Power"* ]]; then
    if [[ "${POWER_STATE}" == "On" ]]; then
        bluetoothctl power off
        notify-send "Bluetooth" "Powered Off"
    else
        bluetoothctl power on
        notify-send "Bluetooth" "Powered On"
    fi
else
    MAC=$(echo "$CHOICE" | awk '{print $1}')
    
    # Strict validation: Only allow valid MAC addresses (e.g. 00:11:22:33:44:55)
    if [[ ! "$MAC" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
        notify-send -u critical "Bluetooth" "Invalid device address selected."
        exit 1
    fi

    notify-send "Bluetooth" "Connecting to $MAC..."
    if bluetoothctl connect "$MAC"; then
        notify-send "Bluetooth" "Connected to $MAC"
    else
        notify-send -u critical "Bluetooth" "Failed to connect to $MAC"
    fi
fi
