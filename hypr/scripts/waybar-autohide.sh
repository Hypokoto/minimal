#!/usr/bin/env bash
# Minimal — Waybar Lifecycle & Low Battery Daemon
#
# Waybar visibility is managed strictly by:
# 1. Shortcut key: SUPER + B (executes waybar-toggle.sh via SIGUSR1)
# 2. Low battery event: Auto-reveals Waybar via SIGUSR2 when battery <= 20%

BAT_THRESHOLD=20   # Reveal Waybar when battery drops to or below this percentage
POLL_INTERVAL=5    # Seconds between battery level checks
LOG_FILE="/tmp/waybar-autohide.log"

get_waybar_pid() {
    pgrep -x waybar | head -n1
}

start_waybar() {
    pkill -x waybar 2>/dev/null
    sleep 0.3
    waybar &

    for _ in $(seq 1 50); do
        [ -n "$(get_waybar_pid)" ] && break
        sleep 0.1
    done
}

# Start Waybar if not running
if [ -z "$(get_waybar_pid)" ]; then
    start_waybar
fi

if [ -z "$(get_waybar_pid)" ]; then
    echo "$(date '+%H:%M:%S') waybar failed to start, aborting" >> "$LOG_FILE"
    exit 1
fi

echo "$(date '+%H:%M:%S') daemon started, pid=$(get_waybar_pid)" > "$LOG_FILE"

# Initial state: hidden
pid=$(get_waybar_pid)
[ -n "$pid" ] && kill -SIGUSR1 "$pid" 2>/dev/null

was_low_battery=false

while true; do
    # 1. Keep Waybar process alive
    pid=$(get_waybar_pid)
    if [ -z "$pid" ]; then
        echo "$(date '+%H:%M:%S') waybar process lost, restarting..." >> "$LOG_FILE"
        start_waybar
        pid=$(get_waybar_pid)
        [ -n "$pid" ] && kill -SIGUSR1 "$pid" 2>/dev/null
    fi

    # 2. Monitor battery status
    is_low=false
    current_cap=""
    current_stat=""

    for bat in /sys/class/power_supply/BAT*; do
        if [ -f "$bat/capacity" ]; then
            cap=$(cat "$bat/capacity" 2>/dev/null)
            stat=$(cat "$bat/status" 2>/dev/null)
            if [ -n "$cap" ]; then
                current_cap="$cap"
                current_stat="$stat"
                if [ "$cap" -le "$BAT_THRESHOLD" ] && [ "$stat" != "Charging" ] && [ "$stat" != "Full" ]; then
                    is_low=true
                    break
                fi
            fi
        fi
    done

    # 3. Handle low battery triggers
    if [ "$is_low" = true ]; then
        if [ "$was_low_battery" = false ]; then
            echo "$(date '+%H:%M:%S') Low battery triggered: ${current_cap}% (${current_stat}). Revealing Waybar." >> "$LOG_FILE"
            pid=$(get_waybar_pid)
            if [ -n "$pid" ]; then
                kill -SIGUSR2 "$pid" 2>/dev/null
            fi
            notify-send -u critical -i battery-caution "Low Battery (${current_cap}%)" "Waybar revealed due to low battery." 2>/dev/null || true
            was_low_battery=true
        fi
    else
        if [ "$was_low_battery" = true ]; then
            echo "$(date '+%H:%M:%S') Battery condition restored: ${current_cap}% (${current_stat})." >> "$LOG_FILE"
            was_low_battery=false
        fi
    fi

    sleep "$POLL_INTERVAL"
done
