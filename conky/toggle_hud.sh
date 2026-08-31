#!/usr/bin/env bash

# Check if our specific Conky instance is running
if pgrep -f "conky -c .*security-hud.conf" > /dev/null; then
    # Kill it if running
    pkill -f "conky -c .*security-hud.conf"
else
    # Start it in the background if not running
    conky -c ~/.config/conky/security-hud.conf &
fi
