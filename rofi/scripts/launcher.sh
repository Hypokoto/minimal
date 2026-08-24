#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rofi -pid /tmp/rofi-launcher.pid -show drun -theme "${DIR}/launcher.rasi"
