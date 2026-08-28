#!/usr/bin/env bash
# Quick toggle script between Laptop Speakers and HDMI / TV Output
set -euo pipefail

CURRENT_SINK="$(pactl info | grep "Default Sink" | awk '{print $3}')"

HDMI_SINK="$(pactl list sinks short | grep -i "pci-0000_03_00.1\|pci-0000_08_00.1" | awk '{print $2}' | head -n 1 || true)"
SPEAKER_SINK="$(pactl list sinks short | grep -i "Speaker" | awk '{print $2}' | head -n 1 || true)"

if [[ -z "$HDMI_SINK" ]]; then
    # Enable pro-audio profile if HDMI profile is inactive
    pactl set-card-profile alsa_card.pci-0000_03_00.1 pro-audio 2>/dev/null || true
    pactl set-card-profile alsa_card.pci-0000_08_00.1 pro-audio 2>/dev/null || true
    HDMI_SINK="$(pactl list sinks short | grep -i "pci-0000_03_00.1\|pci-0000_08_00.1" | awk '{print $2}' | head -n 1 || true)"
fi

if [[ "$CURRENT_SINK" == "$SPEAKER_SINK" && -n "$HDMI_SINK" ]]; then
    pactl set-default-sink "$HDMI_SINK"
    notify-send -r 91110 -a "minimal-osd" -i "audio-speakers-symbolic" "Audio Output" "Switched to TV / HDMI Output"
else
    if [[ -n "$SPEAKER_SINK" ]]; then
        pactl set-default-sink "$SPEAKER_SINK"
        notify-send -r 91110 -a "minimal-osd" -i "audio-speakers-symbolic" "Audio Output" "Switched to Laptop Speaker"
    fi
fi
