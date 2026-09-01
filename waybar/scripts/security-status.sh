#!/usr/bin/env bash
set -euo pipefail

# 1. Check Firewall
fw_status=$(systemctl is-active nftables 2>/dev/null || echo "inactive")

# 2. Check Failed Services
failed_services=$(systemctl --failed --no-legend 2>/dev/null | wc -l || echo 0)

# 3. Check Network Listeners (excluding loopback)
# ss -tuln gives TCP/UDP listening ports. grep -v '127.0.0.1\|::1' excludes localhost.
listeners=$(ss -tuln 2>/dev/null | grep -E "^(tcp|udp)" | grep -v -c '127\.0\.0\.1\|::1' || echo 0)

status="SECURE"
icon="󰒔"
class="secure"
reason="All checks passed."

if [ "${fw_status}" != "active" ]; then
    status="WARNING"
    class="warning"
    reason="Firewall is ${fw_status}."
fi

if [ "${listeners}" -gt 5 ]; then
    status="WARNING"
    class="warning"
    reason="High number of external listeners (${listeners})."
fi

if [ "${failed_services}" -gt 0 ]; then
    status="DEGRADED"
    class="degraded"
    reason="${failed_services} systemd service(s) failed."
fi

tooltip="STATE: ${status}\nREASON: ${reason}\n\nFirewall: ${fw_status}\nFailed Services: ${failed_services}\nExternal Listeners: ${listeners}"

# Output JSON for Waybar
jq -n -c \
    --arg text "${icon} ${status}" \
    --arg tooltip "${tooltip}" \
    --arg class "${class}" \
    '{text: $text, tooltip: $tooltip, class: $class}'
