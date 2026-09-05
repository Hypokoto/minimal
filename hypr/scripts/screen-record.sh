#!/usr/bin/env bash
# ==============================================================================
# screen-record.sh — High-Performance Screen Recording Tool for Hyprland
# Usage:
#   screen-record.sh           # Toggle 60fps fullscreen recording
#   screen-record.sh --region  # Toggle selected region recording
#   screen-record.sh --audio   # Toggle fullscreen recording with system audio
# ==============================================================================
set -euo pipefail

RECORDINGS_DIR="${HOME}/Pictures/recordings"

# If wf-recorder is currently running, stop it cleanly
if pgrep -x wf-recorder >/dev/null 2>&1; then
	pkill -SIGINT wf-recorder || true
	notify-send -t 3000 -i video-x-generic "Screen Recorder" "Recording saved to ~/Pictures/recordings"
	exit 0
fi

# Ensure recordings directory exists
mkdir -p "$RECORDINGS_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="${RECORDINGS_DIR}/recording-${TIMESTAMP}.mp4"

MODE="${1:-}"
EXTRA_ARGS=("-r" "60")

if [ "$MODE" = "--region" ]; then
	GEOM=$(slurp -b "#00000080" -c "#7dd3fcff" -w 1 2>/dev/null) || {
		notify-send -t 1500 "Screen Recorder" "Region selection cancelled"
		exit 0
	}
	EXTRA_ARGS+=("-g" "$GEOM")
elif [ "$MODE" = "--audio" ]; then
	EXTRA_ARGS+=("-a")
fi

# Send quick notification BEFORE recording starts (fades in 1.5s so it doesn't pollute the video)
notify-send -t 1500 -i media-record "Screen Recorder" "Recording started (60 FPS)...\nPress SUPER+SHIFT+R to stop"

# Brief sleep to allow notification popup to fade before frame capture starts
sleep 0.8

# Launch wf-recorder
wf-recorder "${EXTRA_ARGS[@]}" -f "$OUTPUT_FILE" >/dev/null 2>&1 &
