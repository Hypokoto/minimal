#!/usr/bin/env bash
# ==============================================================================
# Minimal — Security Dashboard (Rofi)
#
# Live network status header + tool launcher.
# Left-click the Waybar shield → opens this.
# SUPER+S → opens this from anywhere.
#
# Sections:
#   [STATUS]  Live interface, IP, active connections count
#   [SCAN]    rustscan, nmap shorthand
#   [WEB]     feroxbuster, xh
#   [MONITOR] sniffnet, bandwhich, trippy, netscanner
#   [UTILS]   hexyl, cargo-audit, iperf3, sslinfo
# ==============================================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}") /.." && pwd)"
THEME_PATH="${DIR}/security.rasi"

# ── Live status header (shown as rofi message) ──────────────────────────────
PUB_IP="$(curl -s --max-time 3 https://icanhazip.com 2>/dev/null | tr -d '[:space:]' || echo '?')"
IFACE="$(ip route show default 2>/dev/null | awk '/default/ {print $5; exit}' || echo '?')"
LOCAL_IP="$(ip -4 addr show "${IFACE}" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 || echo '?')"
CONN_COUNT="$(ss -tp state established 2>/dev/null | grep -c ESTAB || true)"
ESSID="$(iwgetid -r 2>/dev/null || echo '')"
if [[ -n "$ESSID" ]]; then
    NET_LABEL="󰤨  ${ESSID}"
else
    NET_LABEL="󰈀  ${IFACE}"
fi

MSG="<span foreground='#8D95B3'>iface</span> <span foreground='#F2F6FF'>${NET_LABEL}</span>   <span foreground='#8D95B3'>local</span> <span foreground='#00D9FF'>${LOCAL_IP}</span>   <span foreground='#8D95B3'>pub</span> <span foreground='#61E6FF'>${PUB_IP}</span>   <span foreground='#8D95B3'>estab</span> <span foreground='#4DFF91'>${CONN_COUNT}</span>"

# ── Menu entries ─────────────────────────────────────────────────────────────
# Format: "ICON  Label|command-to-run-in-terminal"
#   Entries with a terminal command are launched in kitty.
#   Entries with gui: prefix are launched directly.

declare -A CMDS

# Scan
CMDS["󰐻  Port Scan"]="rustscan -a"
CMDS["  Nmap Quick"]="nmap -sV -T4"
CMDS["  Nmap Full"]="nmap -sV -sC -p- -T4"
CMDS["󰛵  UDP Scan"]="sudo nmap -sU -T4"

# Web
CMDS["󰖟  Web Fuzz"]="feroxbuster -u"
CMDS["  HTTP Client"]="xh"

# Monitor
CMDS["󱛏  Sniffnet"]="gui:sudo sniffnet"
CMDS["󰐻  Bandwidth"]="sudo bandwhich"
CMDS["󰁫  Trace Route"]="sudo trip"
CMDS["  LAN Scan"]="sudo netscanner"

# Analysis
CMDS["  Hex View"]="hexyl"
CMDS["󰒔  Cargo Audit"]="cargo audit"
CMDS["󰓅  Speedtest"]="speedtest-cli"
CMDS["󰓅  Bandwidth Test"]="iperf3 -c"

# Ordered display list
OPTIONS=(
    "󰐻  Port Scan"
    "  Nmap Quick"
    "  Nmap Full"
    "󰛵  UDP Scan"
    "󰖟  Web Fuzz"
    "  HTTP Client"
    "󱛏  Sniffnet"
    "󰐻  Bandwidth"
    "󰁫  Trace Route"
    "  LAN Scan"
    "  Hex View"
    "󰒔  Cargo Audit"
    "󰓅  Speedtest"
    "󰓅  Bandwidth Test"
)

MENU="$(printf '%s\n' "${OPTIONS[@]}")"

ROFI_CMD=(
    rofi -dmenu
    -pid /tmp/rofi-security.pid
    -p "Security"
    -mesg "${MSG}"
    -markup-rows
)

[[ -f "${THEME_PATH}" ]] && ROFI_CMD+=(-theme "${THEME_PATH}")

set +e
CHOICE="$(echo "${MENU}" | "${ROFI_CMD[@]}")"
STATUS=$?
set -e

[[ ${STATUS} -ne 0 || -z "${CHOICE}" ]] && exit 0

CMD="${CMDS["${CHOICE}"]:-}"
[[ -z "$CMD" ]] && exit 0

TERM="${TERMINAL:-kitty}"

if [[ "$CMD" == gui:* ]]; then
    # Run directly (no terminal needed)
    eval "${CMD#gui:}" &
elif [[ "$CMD" == "rustscan -a" || "$CMD" == "nmap"* || "$CMD" == "feroxbuster"* || "$CMD" == "iperf3"* ]]; then
    # Prompt for target
    TARGET="$(rofi -dmenu -p "Target" -theme "${THEME_PATH}" <<< "")"
    [[ -z "$TARGET" ]] && exit 0
    "${TERM}" -- bash -c "${CMD} ${TARGET}; echo; echo '--- Press Enter to close ---'; read -r" &
elif [[ "$CMD" == "hexyl" ]]; then
    FILE="$(rofi -dmenu -p "File path" -theme "${THEME_PATH}" <<< "")"
    [[ -z "$FILE" ]] && exit 0
    "${TERM}" -- bash -c "hexyl ${FILE} | less -R; echo; read -r" &
else
    "${TERM}" -- bash -c "${CMD}; echo; echo '--- Press Enter to close ---'; read -r" &
fi
