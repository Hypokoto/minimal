#!/usr/bin/env bash
# ==============================================================================
# Minimal Rofi Power Menu Suite
# Interfaced with hyprctl dispatch exit, systemctl suspend, reboot, poweroff
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

OPTIONS=$'Shutdown\nReboot\nSuspend\nLock\nLog Out'

THEME_PATH="${DIR}/powermenu.rasi"
ROFI_CMD=(rofi -dmenu -p "Power" -u "0" -a "1")

if [[ -f "${THEME_PATH}" ]]; then
    ROFI_CMD+=(-theme "${THEME_PATH}")
fi

set +e
CHOICE="$(echo -n "${OPTIONS}" | "${ROFI_CMD[@]}")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

case "${CHOICE}" in
    "Shutdown")
        notify-send -u critical "Power" "Shutting down..."
        systemctl poweroff
        ;;
    "Reboot")
        notify-send -u critical "Power" "Rebooting system..."
        systemctl reboot
        ;;
    "Suspend")
        notify-send "Power" "Suspending session..."
        systemctl suspend
        ;;
    "Lock")
        if command -v hyprlock >/dev/null 2>&1; then
            hyprlock
        else
            notify-send -u warning "Power" "hyprlock binary not found"
        fi
        ;;
    "Log Out")
        notify-send "Power" "Exiting Hyprland session..."
        if command -v hyprctl >/dev/null 2>&1; then
            hyprctl dispatch exit
        else
            loginctl terminate-user "$USER"
        fi
        ;;
    *)
        exit 0
        ;;
esac
