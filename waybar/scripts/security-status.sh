#!/usr/bin/env bash
set -euo pipefail

# Check Firewall (nftables)
fw_status=$(systemctl is-active nftables 2>/dev/null || echo "inactive")

# Check Failed Services
failed_services=$(systemctl --failed --no-legend 2>/dev/null | wc -l || echo 0)

status="SECURE"
icon="󰒔"
class="secure"
tooltip="Firewall: ${fw_status}\nFailed services: ${failed_services}"

if [ "${fw_status}" != "active" ]; then
    status="WARNING"
    icon="󰒔"
    class="warning"
fi

if [ "${failed_services}" -gt 0 ]; then
    status="DEGRADED"
    icon="󰒔"
    class="degraded"
fi

# Output JSON for Waybar
jq -n -c \
    --arg text "${icon} ${status}" \
    --arg tooltip "${tooltip}" \
    --arg class "${class}" \
    '{text: $text, tooltip: $tooltip, class: $class}'
