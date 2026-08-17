#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

if (($# != 1)); then
    printf 'Usage: %s <wallpaper-path>\n' "${0##*/}" >&2
    exit 64
fi

wallpaper_path="$1"
if ! is_valid_wallpaper "${wallpaper_path}"; then
    notify critical "Wallpaper unavailable" "Choose a readable PNG, JPG, JPEG, or WebP image."
    exit 1
fi

require_command awww || exit 1
if ! pgrep -x awww-daemon >/dev/null 2>&1; then
    notify critical "awww daemon is not running" "Start awww-daemon from Hyprland and try again."
    exit 1
fi

if ! awww img "${wallpaper_path}"; then
    notify critical "Wallpaper change failed" "awww could not apply the selected image."
    exit 1
fi

write_current_wallpaper "${wallpaper_path}"
notify normal "Wallpaper applied" "$(basename -- "${wallpaper_path}")"

