#!/usr/bin/env bash
set -euo pipefail

echo "=== Validating Package Tiers ==="

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
    echo "ERROR: Duplicate packages found across tiers:"
    echo "$DUPLICATES"
    exit 1
fi

echo "Package tiers are strictly categorized and contain no duplicates or banned tools."
exit 0
