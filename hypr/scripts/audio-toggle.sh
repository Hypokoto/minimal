#!/usr/bin/env bash
# Quick toggle script between Laptop Speakers and HDMI / TV Outputs
set -euo pipefail

# Ensure both HDMI card profiles are active
pactl set-card-profile alsa_card.pci-0000_03_00.1 pro-audio 2>/dev/null || true
pactl set-card-profile alsa_card.pci-0000_08_00.1 pro-audio 2>/dev/null || true

SINKS=($(pactl list sinks short | awk '{print $2}'))
CURRENT="$(pactl info | grep "Default Sink" | awk '{print $2}')"

if [[ ${#SINKS[@]} -eq 0 ]]; then
    exit 0
fi

NEXT_SINK="${SINKS[0]}"
for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#SINKS[@]} ))
        NEXT_SINK="${SINKS[$NEXT_INDEX]}"
        break
    fi
done

pactl set-default-sink "$NEXT_SINK"

LABEL="Default Audio Output"
if [[ "$NEXT_SINK" == *"Speaker"* ]]; then
    LABEL="Laptop Speakers"
elif [[ "$NEXT_SINK" == *"08_00.1"* ]]; then
    LABEL="TV / HDMI Audio (iGPU)"
elif [[ "$NEXT_SINK" == *"03_00.1"* ]]; then
    LABEL="TV / HDMI Audio (dGPU)"
fi

notify-send -r 91110 -a "minimal-osd" -i "audio-speakers-symbolic" "Audio Output" "Switched to $LABEL"
