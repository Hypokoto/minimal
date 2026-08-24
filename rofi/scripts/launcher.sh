#!/usr/bin/env bash
set -euo pipefail
pkill -x rofi || true

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rofi -show drun -theme "${DIR}/launcher.rasi"
