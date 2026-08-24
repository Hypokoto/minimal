#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ASSUMPTION (undocumented in spec, stated explicitly): agenda file is
# plain text, one entry per line, format `YYYY-MM-DD;Event text`.
# Override with AGENDA_FILE env var if your layout differs.
AGENDA_FILE="${AGENDA_FILE:-$HOME/dev/vault/agenda.txt}"

TODAY_DAY="$(date +%-d)"
TODAY_ISO="$(date +%Y-%m-%d)"

CAL_OUTPUT="$(cal | tail -n +2)"

# We use Pango markup to highlight today's date without breaking the monospace
# grid alignment (which the previous awk script broke by collapsing spaces).
CAL_MARKED="$(echo "${CAL_OUTPUT}" | sed -E "s/\b${TODAY_DAY}\b/<b><u>&<\/u><\/b>/")"

# Find which line (1-indexed within the full menu) holds the marked day.
ACTIVE_LINE_IDX="$(grep -n "<b><u>" <<< "${CAL_MARKED}" | head -n1 | cut -d: -f1 || true)"

AGENDA_HEADER="── Agenda ──"
if [[ -r "${AGENDA_FILE}" ]]; then
    AGENDA_ENTRIES="$(awk -F';' -v today="${TODAY_ISO}" '
        $1 >= today { printf "%s  %s\n", $1, $2 }
    ' "${AGENDA_FILE}" | sort | head -n 10)"
else
    AGENDA_ENTRIES="(no agenda file at ${AGENDA_FILE})"
fi

FULL_MENU="$(printf '%s\n\n%s\n%s\n' "${CAL_MARKED}" "${AGENDA_HEADER}" "${AGENDA_ENTRIES}")"

# Recompute indices against the FULL menu (cal block + blank + header + entries).
CAL_LINE_COUNT="$(wc -l <<< "${CAL_MARKED}")"
HEADER_IDX=$((CAL_LINE_COUNT + 2))          # +1 blank line, 1-indexed -> next line is header
AGENDA_START_IDX=$((HEADER_IDX + 1))
AGENDA_LINE_COUNT="$(wc -l <<< "${AGENDA_ENTRIES}")"

URGENT_INDICES="${HEADER_IDX}"
for ((i = 0; i < AGENDA_LINE_COUNT; i++)); do
    URGENT_INDICES="${URGENT_INDICES},$((AGENDA_START_IDX + i))"
done

ACTIVE_ARG=()
if [[ -n "${ACTIVE_LINE_IDX:-}" ]]; then
    ACTIVE_ARG=(-a "$((ACTIVE_LINE_IDX - 1))")
fi

rofi -dmenu -pid /tmp/rofi-calendar.pid \
    -theme "${DIR}/calendar.rasi" \
    -p "$(date +'%B %Y')" \
    -no-custom \
    -markup-rows \
    "${ACTIVE_ARG[@]}" \
    -u "${URGENT_INDICES}" \
    <<< "${FULL_MENU}" >/dev/null
