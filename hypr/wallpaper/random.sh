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

exec "${SCRIPT_DIR}/apply.sh" "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
