#!/usr/bin/env bash
set -euo pipefail

echo "=== Validating Package Tiers & Source Provenance ==="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PKG_DIR="$SCRIPT_DIR/packages"

if [ ! -d "$PKG_DIR" ]; then
    echo "ERROR: packages directory not found."
    exit 1
fi

# 1. Ban list check
BANNED_PKGS=("conky" "nm-applet" "nwg-drawer" "hyprlauncher" "hyprpaper")

for pkg in "${BANNED_PKGS[@]}"; do
    if grep -r -q -x "$pkg" "$PKG_DIR"; then
        echo "ERROR: Banned package '$pkg' found in package lists!"
        exit 1
    fi
done

# 2. Duplicate check across all tiers
ALL_PKGS=$(cat "$PKG_DIR"/*.txt | grep -vE '^\s*#|^\s*$' | sort)
DUPLICATES=$(echo "$ALL_PKGS" | uniq -d)

if [ -n "$DUPLICATES" ]; then
    echo "ERROR: Duplicate packages found across package files:"
    echo "$DUPLICATES"
    exit 1
fi

# 3. Official Repository Provenance Check for Core & CLI
if command -v pacman >/dev/null 2>&1; then
    OFFICIAL_LIST=$(mktemp /tmp/official_pkgs.XXXXXX)
    pacman -Sl | awk '{print $2}' | sort -u > "$OFFICIAL_LIST"

    for file in "$PKG_DIR/core.txt" "$PKG_DIR/cli.txt"; do
        file_base="$(basename "$file")"
        while read -r pkg; do
            [[ -z "$pkg" || "$pkg" == "#"* ]] && continue
            if ! grep -q -x "$pkg" "$OFFICIAL_LIST"; then
                echo "ERROR: Package '$pkg' in $file_base is NOT in official Arch repositories!"
                rm -f "$OFFICIAL_LIST"
                exit 1
            fi
        done < "$file"
    done
    rm -f "$OFFICIAL_LIST"
fi

echo "Package tiers and source provenance validation passed."
exit 0
