#!/usr/bin/env bash
set -euo pipefail
pkill -x rofi || true

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v nmcli >/dev/null 2>&1; then
    notify-send -u critical "Network" "nmcli not found"
    exit 1
fi

RADIO_STATE="$(nmcli radio wifi)"          # "enabled" | "disabled"
TOGGLE_LABEL="Wi-Fi: $([[ "${RADIO_STATE}" == "enabled" ]] && echo "ON (click to disable)" || echo "OFF (click to enable)")"

build_menu() {
    printf '%s\n' "${TOGGLE_LABEL}"

    [[ "${RADIO_STATE}" != "enabled" ]] && return 0

    # Force a fresh scan so signal strengths aren't stale.
    nmcli device wifi rescan >/dev/null 2>&1 || true

    # -t: terse/machine output, -f: fields. Dedup by SSID keeping strongest.
    nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list \
        | awk -F':' '
            $2 != "" {
                key=$2
                sig=$3+0
                if (!(key in seen) || sig > seen[key]) {
                    seen[key]=sig
                    inuse[key]=$1
                    sec[key]=$4
                }
            }
            END {
                for (k in seen) {
                    marker = (inuse[k] == "*") ? " [connected]" : ""
                    lock = (sec[k] != "" && sec[k] != "--") ? " 🔒" : ""
                    printf "%s  %s%%%s%s\n", k, seen[k], lock, marker
                }
            }' \
        | sort -t' ' -k2 -rn
}

MENU="$(build_menu)"

# Index of the currently-connected SSID line, for the -a (active) marker.
ACTIVE_IDX="$(printf '%s\n' "${MENU}" | grep -n '\[connected\]' | head -n1 | cut -d: -f1)"
ACTIVE_ARG=()
if [[ -n "${ACTIVE_IDX:-}" ]]; then
    ACTIVE_ARG=(-a "$((ACTIVE_IDX - 1))")
fi

set +e
CHOICE="$(printf '%s\n' "${MENU}" | rofi -dmenu \
    -theme "${DIR}/network.rasi" \
    -p "Network" \
    "${ACTIVE_ARG[@]}")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

if [[ "${CHOICE}" == "${TOGGLE_LABEL}" ]]; then
    if [[ "${RADIO_STATE}" == "enabled" ]]; then
        nmcli radio wifi off
        notify-send "Network" "Wi-Fi disabled"
    else
        nmcli radio wifi on
        notify-send "Network" "Wi-Fi enabled"
    fi
    exit 0
fi

SSID="$(sed -E 's/  [0-9]+%.*$//' <<< "${CHOICE}")"

if grep -q '\[connected\]' <<< "${CHOICE}"; then
    notify-send "Network" "Already connected to ${SSID}"
    exit 0
fi

IS_SECURED=false
grep -q '🔒' <<< "${CHOICE}" && IS_SECURED=true

if [[ "${IS_SECURED}" == false ]]; then
    if nmcli device wifi connect "${SSID}" >/tmp/nmcli-connect.$$ 2>&1; then
        notify-send "Network" "Connected to ${SSID}"
    else
        notify-send -u critical "Network" "Failed to connect to ${SSID}"
    fi
    rm -f /tmp/nmcli-connect.$$
    exit 0
fi

set +e
PASSWORD="$(rofi -dmenu -password -theme "${DIR}/network.rasi" -p "Password for ${SSID}")"
PW_STATUS=$?
set -e

if [[ ${PW_STATUS} -ne 0 || -z "${PASSWORD}" ]]; then
    exit 0
fi

# SECURITY: password is piped via stdin to `nmcli --ask`, never passed as
# a CLI argument. `nmcli device wifi connect SSID password PASS` would put
# the plaintext password in argv, visible to any user on the box via
# `ps aux` for the process's lifetime. --ask makes nmcli prompt for the
# secret and read it from stdin instead.
if printf '%s\n' "${PASSWORD}" | nmcli --ask device wifi connect "${SSID}" >/tmp/nmcli-connect.$$ 2>&1; then
    notify-send "Network" "Connected to ${SSID}"
else
    notify-send -u critical "Network" "Failed to connect to ${SSID} — check password"
fi

# Best-effort scrub of the transient log and the shell variable.
rm -f /tmp/nmcli-connect.$$
unset PASSWORD
