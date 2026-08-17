#!/usr/bin/env bash
# Minimal — Toggle Waybar visibility via shortcut key

pid=$(pgrep -x waybar | head -n1)

if [ -n "$pid" ]; then
    kill -SIGUSR1 "$pid"
else
    waybar &
fi
