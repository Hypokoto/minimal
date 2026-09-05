#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

require_command rofi || exit 1
require_command magick || exit 1
ensure_cache_directories

declare -a wallpapers=()
declare -a displayed_wallpapers=()
declare -A basename_counts=()
load_wallpapers wallpapers

if ((${#wallpapers[@]} == 0)); then
	notify normal "No wallpapers found" "Add PNG, JPG, JPEG, or WebP files to ${WALLPAPER_DIR}."
	exit 0
fi

for wallpaper_path in "${wallpapers[@]}"; do
	filename="${wallpaper_path##*/}"
	count="${basename_counts["${filename}"]:-0}"
	basename_counts["${filename}"]=$((count + 1))
done

entries_file="$(mktemp "${CACHE_DIR}/picker.XXXXXX")"
trap 'rm -f -- "${entries_file}"' EXIT

for wallpaper_path in "${wallpapers[@]}"; do
	thumbnail_path="$(create_thumbnail "${wallpaper_path}" || true)"
	[[ -n "${thumbnail_path}" ]] || continue

	label="${wallpaper_path##*/}"
	if ((basename_counts["${label}"] > 1)); then
		label="${label} — $(relative_wallpaper_path "${wallpaper_path}")"
	fi
	printf '%s\0icon\x1f%s\n' "${label}" "${thumbnail_path}" >>"${entries_file}"
	displayed_wallpapers+=("${wallpaper_path}")
done

selection_index="$(rofi -dmenu -i -show-icons -format i -theme "${SCRIPT_DIR}/rofi/wallpaper.rasi" <"${entries_file}" || true)"
[[ "${selection_index}" =~ ^[0-9]+$ ]] || exit 0

if ((selection_index >= 0 && selection_index < ${#displayed_wallpapers[@]})); then
	exec "${SCRIPT_DIR}/apply.sh" "${displayed_wallpapers[selection_index]}"
fi
