#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

get_current() {
    if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl get
    elif command -v cpupower >/dev/null 2>&1; then
        cpupower frequency-info -p 2>/dev/null | grep -oP '(?<=governor ")[a-z]+' || echo "unknown"
    else
        echo "unknown"
    fi
}

set_profile() {
    local target="$1"
    if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl set "${target}"
        return
    fi
    # Fallback: no powerprofilesctl on this system (e.g. tlp-only setups).
    # tlp itself doesn't expose a clean 3-way perf/balanced/saver switch —
    # this maps onto cpupower governors instead. Assumption stated: if
    # neither backend exists, the script fails loudly rather than pretending.
    if command -v cpupower >/dev/null 2>&1; then
        case "${target}" in
            performance)  sudo cpupower frequency-set -g performance >/dev/null ;;
            balanced)     sudo cpupower frequency-set -g schedutil   >/dev/null 2>/dev/null || \
                          sudo cpupower frequency-set -g ondemand    >/dev/null ;;
            power-saver)  sudo cpupower frequency-set -g powersave   >/dev/null ;;
        esac
    else
        notify-send -u critical "Power profile" "No powerprofilesctl or cpupower found"
        exit 1
    fi
}

CURRENT="$(get_current)"

OPTIONS=$'Performance\nBalanced\nPower Saver'

set +e
CHOICE="$(echo -n "${OPTIONS}" | rofi -dmenu \
    -theme "${DIR}/battery.rasi" \
    -p "Profile: ${CURRENT}" \
    -u "0" \
    -a "1")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

case "${CHOICE}" in
    "Performance") set_profile "performance" ;;
    "Balanced")    set_profile "balanced" ;;
    "Power Saver") set_profile "power-saver" ;;
esac

notify-send "Power profile" "Set to ${CHOICE}"
