#!/usr/bin/env bash
# ==============================================================================
# screen-record.sh — Screen Recording Tool for Hyprland / Quickshell
# Usage:
#   screen-record.sh           # Toggle fullscreen recording
#   screen-record.sh --region  # Toggle selected region recording
# ==============================================================================
set -euo pipefail

RECORDINGS_DIR="${HOME}/Pictures/recordings"

# If wf-recorder is currently running, stop it cleanly
if pgrep -x wf-recorder >/dev/null 2>&1; then
    pkill -SIGINT wf-recorder || true
    notify-send -i video-x-generic "Screen Recorder" "Recording stopped and saved to ~/Pictures/recordings"
    exit 0
fi

# Ensure recordings directory exists
mkdir -p "$RECORDINGS_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="${RECORDINGS_DIR}/recording-${TIMESTAMP}.mp4"

MODE="${1:-}"
EXTRA_ARGS=()

if [ "$MODE" = "--region" ]; then
    GEOM=$(slurp -b "#00000080" -c "#7dd3fcff" -w 1 2>/dev/null) || {
        notify-send "Screen Recorder" "Region selection cancelled"
        exit 0
    }
    EXTRA_ARGS+=("-g" "$GEOM")
fi

# Launch wf-recorder
wf-recorder "${EXTRA_ARGS[@]}" -f "$OUTPUT_FILE" >/dev/null 2>&1 &

notify-send -i media-record "Screen Recorder" "Recording started...\nPress SUPER+SHIFT+R to stop"
