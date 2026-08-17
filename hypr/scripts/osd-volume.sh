#!/usr/bin/env bash
# Mako replaceable notification OSD widget.
# Uses explicit replaceable notification ID -r 91110 and synchronous hint osd to eliminate message stack latency.
set -euo pipefail

VOL="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')"
MUTED="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED || true)"

ICON="audio-volume-high-symbolic"
[[ "$VOL" -lt 30 ]] && ICON="audio-volume-low-symbolic"
[[ "$MUTED" -gt 0 ]] && ICON="audio-volume-muted-symbolic"

notify-send -r 91110 -h int:value:"$VOL" -h string:x-canonical-private-synchronous:osd \
  -a "minimal-osd" -i "$ICON" "Volume" "${VOL}%"
