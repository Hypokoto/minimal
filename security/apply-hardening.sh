#!/usr/bin/env bash
# ==============================================================================
# Minimal System Hardening Pipeline
# Mitigates CVE-2026-31431 (Copy Fail) and CVE-2026-53362 (IPv6 Kernel)
# ==============================================================================
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== System Hardening ==="

# 1. System Package Updates (Kernel patching)
echo "[*] Updating system packages to patch recent vulnerabilities (Copy Fail / IPv6)..."
if command -v yay >/dev/null 2>&1; then
    yay -Syu --noconfirm || echo "[-] WARN: System update failed (AUR timeout?). Continuing with local hardening..."
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --noconfirm || echo "[-] WARN: System update failed. Continuing with local hardening..."
else
    echo "[-] WARN: Arch Linux package manager not found. Skipping pacman updates."
fi

# 2. Sysctl Deployment
echo "[*] Deploying sysctl security hardening rules..."
if [[ -d /etc/sysctl.d ]]; then
    sudo cp "$DIR/99-security-hardening.conf" /etc/sysctl.d/
    sudo sysctl --system
else
    echo "[-] WARN: /etc/sysctl.d/ not found. Are you on a supported Linux?"
fi

echo "=== Hardening Complete ==="
