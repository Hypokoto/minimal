#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

current_wallpaper="$(read_current_wallpaper || true)"
[[ -n "${current_wallpaper}" ]] || exit 0
exec "${SCRIPT_DIR}/apply.sh" "${current_wallpaper}"
