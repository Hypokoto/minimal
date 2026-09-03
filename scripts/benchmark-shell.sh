#!/usr/bin/env bash
# Minimal Desktop Shell Benchmark Suite
# Measures Quickshell memory footprint, CPU utilization, and IPC responsiveness.

set -euo pipefail

log() {
    echo -e "\033[1;34m[BENCHMARK]\033[0m $1"
}

log "=== MINIMAL SHELL PERFORMANCE TELEMETRY ==="

# 1. Process Check
QS_PID=$(pgrep -f "quickshell" | head -n 1 || true)

if [[ -z "$QS_PID" ]]; then
    log "Quickshell is not running. Starting daemon for benchmark..."
    quickshell --daemonize
    sleep 1
    QS_PID=$(pgrep -f "quickshell" | head -n 1)
fi

log "Quickshell PID: $QS_PID"

# 2. Memory Footprint (RSS / VSZ)
RSS_KB=$(ps -o rss= -p "$QS_PID" | tr -d ' ')
RSS_MB=$(awk "BEGIN {printf \"%.2f\", $RSS_KB / 1024}")
VSZ_KB=$(ps -o vsz= -p "$QS_PID" | tr -d ' ')
VSZ_MB=$(awk "BEGIN {printf \"%.2f\", $VSZ_KB / 1024}")

log "Memory RSS: ${RSS_MB} MB (${RSS_KB} KB)"
log "Memory VSZ: ${VSZ_MB} MB (${VSZ_KB} KB)"

# 3. CPU Utilization Check
CPU_USAGE=$(ps -p "$QS_PID" -o %cpu= | tr -d ' ')
log "CPU Utilization (process average): ${CPU_USAGE}%"

# 4. IPC Response Latency Test
log "Testing IPC Theme Reload Latency..."
START_TIME=$(date +%s%N)
quickshell ipc call minimal-shell reloadTheme >/dev/null 2>&1 || true
END_TIME=$(date +%s%N)
LATENCY_MS=$(( (END_TIME - START_TIME) / 1000000 ))

log "IPC reloadTheme Latency: ${LATENCY_MS} ms"

log "=== BENCHMARK COMPLETE ==="
