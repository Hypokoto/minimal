#!/usr/bin/env bash
# User configuration for the Hyprland wallpaper dashboard.

WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"
CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/wallpaper"
STATE_FILE="${CACHE_DIR}/current"
THUMBNAIL_DIR="${CACHE_DIR}/thumbnails"

THUMBNAIL_WIDTH=360
THUMBNAIL_HEIGHT=200

NOTIFY_APP_NAME="Wallpaper"

# Used by the picker action. Leave empty to use xdg-open.
FILE_MANAGER_COMMAND=()
