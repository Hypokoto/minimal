#!/usr/bin/env bash
# Mako replaceable notification OSD widget.
# Uses explicit replaceable notification ID -r 91111 and synchronous hint osd to eliminate message stack latency.
set -euo pipefail

BRI="$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')"

notify-send -r 91111 -h int:value:"$BRI" -h string:x-canonical-private-synchronous:osd \
  -a "aetheria-osd" -i "display-brightness-symbolic" "Brightness" "${BRI}%"
