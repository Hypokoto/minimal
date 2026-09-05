#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034

WALLPAPER_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../config.sh
source "${WALLPAPER_SCRIPT_DIR}/config.sh"

readonly WALLPAPER_SCRIPT_DIR

ensure_cache_directories() {
	mkdir -p -- "${CACHE_DIR}" "${THUMBNAIL_DIR}"
}

notify() {
	local urgency="$1"
	local summary="$2"
	local body="${3:-}"

	command -v notify-send >/dev/null 2>&1 || return 0
	notify-send -a "${NOTIFY_APP_NAME}" -u "${urgency}" "${summary}" "${body}" >/dev/null 2>&1 || true
}

require_command() {
	local command_name="$1"

	if ! command -v "${command_name}" >/dev/null 2>&1; then
		notify critical "Missing dependency" "Install ${command_name} to use the wallpaper dashboard."
		printf 'wallpaper: missing command: %s\n' "${command_name}" >&2
		return 1
	fi
}

is_supported_wallpaper() {
	local path="$1"
	case "${path,,}" in
	*.png | *.jpg | *.jpeg | *.webp) return 0 ;;
	*) return 1 ;;
	esac
}

is_valid_wallpaper() {
	local path="$1"

	[[ -f "${path}" && -r "${path}" ]] || return 1
	is_supported_wallpaper "${path}" || return 1
	require_command magick || return 1
	magick identify -quiet "${path}" >/dev/null 2>&1
}

load_wallpapers() {
	local -n result="$1"

	result=()
	if [[ ! -d "${WALLPAPER_DIR}" || ! -r "${WALLPAPER_DIR}" ]]; then
		return 0
	fi

	mapfile -d '' -t result < <(
		find "${WALLPAPER_DIR}" -type f -readable \( \
			-iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \
			\) -print0 2>/dev/null | LC_ALL=C sort -z
	)
}

read_current_wallpaper() {
	local current=""

	[[ -r "${STATE_FILE}" ]] || return 1
	IFS= read -r current <"${STATE_FILE}" || return 1
	[[ -n "${current}" && -f "${current}" && -r "${current}" ]] || return 1
	printf '%s\n' "${current}"
}

write_current_wallpaper() {
	local path="$1"
	local temporary_state

	ensure_cache_directories
	temporary_state="$(mktemp "${CACHE_DIR}/current.XXXXXX")"
	printf '%s\n' "${path}" >"${temporary_state}"
	mv -f -- "${temporary_state}" "${STATE_FILE}"
}

thumbnail_path_for() {
	local source_path="$1"
	local relative_path

	relative_path="${source_path#"${WALLPAPER_DIR}"/}"
	printf '%s/%s.png\n' "${THUMBNAIL_DIR}" "${relative_path}"
}

create_thumbnail() {
	local source_path="$1"
	local thumbnail_path

	thumbnail_path="$(thumbnail_path_for "${source_path}")"
	if [[ -f "${thumbnail_path}" && "${thumbnail_path}" -nt "${source_path}" ]]; then
		printf '%s\n' "${thumbnail_path}"
		return 0
	fi

	mkdir -p -- "$(dirname -- "${thumbnail_path}")"
	if ! magick "${source_path}" -auto-orient -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
		-gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "${thumbnail_path}" 2>/dev/null; then
		return 1
	fi

	printf '%s\n' "${thumbnail_path}"
}

relative_wallpaper_path() {
	local source_path="$1"
	printf '%s\n' "${source_path#"${WALLPAPER_DIR}"/}"
}

open_wallpaper_directory() {
	if ((${#FILE_MANAGER_COMMAND[@]})); then
		"${FILE_MANAGER_COMMAND[@]}" "${WALLPAPER_DIR}"
	else
		require_command xdg-open || return 1
		xdg-open "${WALLPAPER_DIR}" >/dev/null 2>&1 &
	fi
}
