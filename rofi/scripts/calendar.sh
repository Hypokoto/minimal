#!/usr/bin/env bash
set -euo pipefail
pkill -x rofi || true

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ASSUMPTION (undocumented in spec, stated explicitly): agenda file is
# plain text, one entry per line, format `YYYY-MM-DD;Event text`.
# Override with AGENDA_FILE env var if your layout differs.
AGENDA_FILE="${AGENDA_FILE:-$HOME/dev/vault/agenda.txt}"

TODAY_DAY="$(date +%-d)"
TODAY_ISO="$(date +%Y-%m-%d)"

CAL_OUTPUT="$(cal)"

# CONSTRAINT, stated explicitly: rofi's rasi highlighting colors whole
# listview elements, not substrings. `cal` renders a day-grid, so a single
# day-of-month cannot be colored independently of the week row it sits in
# with plain dmenu theming — only the entire week-line containing today
# can be marked (-a). To still make today's exact number identifiable at
# a glance, it's bracketed: "07" -> "[7]".
CAL_MARKED="$(awk -v day="${TODAY_DAY}" '
    {
        # Match the day as a whole token (avoid matching inside e.g. "17" for day "7")
        n = split($0, parts, " ")
        out = ""
        for (i = 1; i <= n; i++) {
            if (parts[i] == day) {
                parts[i] = "[" parts[i] "]"
            }
            out = out (i > 1 ? " " : "") parts[i]
        }
        print out
    }' <<< "${CAL_OUTPUT}")"

# Find which line (1-indexed within the full menu) holds the bracketed day.
ACTIVE_LINE_IDX="$(grep -n "\[${TODAY_DAY}\]" <<< "${CAL_MARKED}" | head -n1 | cut -d: -f1)"

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

rofi -dmenu \
    -theme "${DIR}/calendar.rasi" \
    -p "$(date +'%B %Y')" \
    -no-custom \
    "${ACTIVE_ARG[@]}" \
    -u "${URGENT_INDICES}" \
    <<< "${FULL_MENU}" >/dev/null
