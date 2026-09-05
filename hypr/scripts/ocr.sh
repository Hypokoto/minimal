#!/usr/bin/env bash
# ==============================================================================
# ocr.sh — Screen Text Extractor for Hyprland
# Snips a region on screen using slurp/grim, runs tesseract OCR, and copies to clipboard
# ==============================================================================
set -euo pipefail

TMP_IMG="/tmp/ocr_snip.png"

cleanup() {
	rm -f "$TMP_IMG"
}
trap cleanup EXIT INT TERM

REGION=$(slurp -b "#00000080" -c "#7dd3fcff" -w 1 2>/dev/null) || {
	notify-send "OCR Extractor" "Selection cancelled"
	exit 0
}

grim -g "$REGION" "$TMP_IMG" 2>/dev/null

if command -v tesseract >/dev/null 2>&1; then
	TEXT=$(tesseract "$TMP_IMG" stdout -l eng --psm 6 2>/dev/null || true)
	if [ -n "$TEXT" ]; then
		echo -n "$TEXT" | wl-copy
		notify-send -i edit-copy "OCR Extractor" "Extracted text copied to clipboard:\n$TEXT"
	else
		notify-send "OCR Extractor" "No text recognized in selected region"
	fi
else
	wl-copy <"$TMP_IMG"
	notify-send "OCR Extractor" "Image copied to clipboard (Install tesseract for text recognition)"
fi
