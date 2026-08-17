#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

declare -a wallpapers=()
load_wallpapers wallpapers
if ((${#wallpapers[@]} == 0)); then
    notify normal "No wallpapers found" "Add images to ${WALLPAPER_DIR}."
    exit 0
fi

current_wallpaper="$(read_current_wallpaper || true)"
previous_index=$((${#wallpapers[@]} - 1))
for index in "${!wallpapers[@]}"; do
    if [[ "${wallpapers[index]}" == "${current_wallpaper}" ]]; then
        previous_index=$(((index - 1 + ${#wallpapers[@]}) % ${#wallpapers[@]}))
        break
    fi
done

exec "${SCRIPT_DIR}/apply.sh" "${wallpapers[previous_index]}"
