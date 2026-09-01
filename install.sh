#!/usr/bin/env bash
# minimal install.sh — idempotent, non-interactive shell environment installer.
# By default, installs ONLY Tier 0 (Core) and Tier 1 (CLI) packages.
# Usage: ./install.sh [OPTIONS]
# Options:
#   --all               Install all package tiers (Core, CLI, Dev, Network, Optional)
#   --with-dev          Install Tier 2 Development tools
#   --with-network      Install Tier 2 Network tools
#   --with-optional     Install Tier 2 Optional CLI tools
#   --with-chaotic-aur  Explicitly consent to adding the third-party Chaotic-AUR repository
#   --dry-run           Print the operations that would be performed without executing them
#   --help              Show this help message

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
mkdir -p "$STATE_DIR"
LOG_FILE="$STATE_DIR/minimal-install.log"
ARCH="$(uname -m)"

# --- Parse Arguments ---
INSTALL_DEV=false
INSTALL_NET=false
INSTALL_OPT=false
WITH_CHAOTIC_AUR=false
DRY_RUN=false

for arg in "$@"; do
    case $arg in
        --all) INSTALL_DEV=true; INSTALL_NET=true; INSTALL_OPT=true ;;
        --with-dev) INSTALL_DEV=true ;;
        --with-network) INSTALL_NET=true ;;
        --with-optional) INSTALL_OPT=true ;;
        --with-chaotic-aur) WITH_CHAOTIC_AUR=true ;;
        --dry-run) DRY_RUN=true ;;
        --help)
            awk '/^# Usage:/,/^$/' "$0" | sed 's/^# *//'
            exit 0
            ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
die()  { log "FATAL: $1"; exit 1; }
run_cmd() {
    if [[ "$DRY_RUN" == true ]]; then
        log "[DRY RUN] Would execute: $*"
    else
        "$@"
    fi
}

[[ "$ARCH" == "x86_64" ]] || die "Untested arch: $ARCH. Aborting — do not assume compatibility."

log "=== STARTING SYSTEM INSTALLATION ==="

PKG_MGR=""
if command -v pacman >/dev/null 2>&1; then
    PKG_MGR="pacman"
else
    log "WARN: Arch Linux pacman not found."
    log "Skipping system package installation. Only dotfile deployment will run."
fi

if [[ "$PKG_MGR" == "pacman" ]]; then

    if [[ "$WITH_CHAOTIC_AUR" == true ]]; then
        log "WARNING: Adding third-party Chaotic-AUR repository (explicit consent provided)."
        if ! grep -q "\\[chaotic-aur\\]" /etc/pacman.conf; then
            run_cmd sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
            run_cmd sudo pacman-key --lsign-key 3056513887B78AEB
            run_cmd sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
            if [[ "$DRY_RUN" == false ]]; then
                echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
            fi
        fi
        # Prevent partial upgrades: always use -Syu
        run_cmd sudo pacman -Syu --noconfirm
    else
        log "Updating official repositories..."
        run_cmd sudo pacman -Syu --noconfirm
    fi

    if ! command -v yay >/dev/null 2>&1; then
        log "yay not found. Building from official AUR."
        run_cmd sudo pacman -S --needed --noconfirm base-devel git
        if [[ "$DRY_RUN" == false ]]; then
            tmpdir="$(mktemp -d)"
            git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
            (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
            rm -rf "$tmpdir"
        else
            log "[DRY RUN] Would clone and build yay-bin."
        fi
    fi

    read_pkgs() { grep -vE '^\s*#|^\s*$' "$SCRIPT_DIR/packages/$1.txt" || true; }
    
    PKGS_TO_INSTALL=()
    mapfile -t core_pkgs < <(read_pkgs "core")
    mapfile -t cli_pkgs < <(read_pkgs "cli")
    PKGS_TO_INSTALL+=("${core_pkgs[@]}" "${cli_pkgs[@]}")

    if [[ "$INSTALL_DEV" == true ]]; then
        mapfile -t dev_pkgs < <(read_pkgs "dev")
        PKGS_TO_INSTALL+=("${dev_pkgs[@]}")
    fi
    if [[ "$INSTALL_NET" == true ]]; then
        mapfile -t net_pkgs < <(read_pkgs "network")
        PKGS_TO_INSTALL+=("${net_pkgs[@]}")
    fi
    if [[ "$INSTALL_OPT" == true ]]; then
        mapfile -t opt_pkgs < <(read_pkgs "optional")
        PKGS_TO_INSTALL+=("${opt_pkgs[@]}")
    fi

    # Explicitly categorize Official vs AUR packages (naive check via pacman database)
    # Since we can't reliably predict what is AUR vs Official before syncing without parsing pacman output,
    # we use yay but enforce a full system upgrade (-Syu) rather than partial (-S)
    log "Installing ${#PKGS_TO_INSTALL[@]} packages using yay..."
    run_cmd yay -Syu --needed --noconfirm "${PKGS_TO_INSTALL[@]}"

    if [[ "$INSTALL_DEV" == true ]] && ! rustup show >/dev/null 2>&1; then
      log "Initializing rustup default toolchain."
      run_cmd rustup default stable
    fi

    # Enable system services safely
    enable_service_if_exists() {
        if [[ "$DRY_RUN" == true ]]; then
            log "[DRY RUN] Would check and enable service: $1"
        elif systemctl list-unit-files "$1" >/dev/null 2>&1; then
            run_cmd sudo systemctl enable --now "$1"
        fi
    }
    
    enable_service_if_exists NetworkManager.service
    enable_service_if_exists power-profiles-daemon.service
    enable_service_if_exists swayosd-libinput-backend.service

else
    log "Non-Arch system detected. Skipping package management."
fi

ZSH_PATH="$(command -v zsh 2>/dev/null || true)"
if [[ -n "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
  log "Changing default shell to zsh: $ZSH_PATH"
  run_cmd chsh -s "$ZSH_PATH" "$USER"
fi

if [[ -f "$SCRIPT_DIR/deploy.sh" ]]; then
  log "Executing dotfile deployment via deploy.sh..."
  run_cmd bash "$SCRIPT_DIR/deploy.sh"
else
  log "WARN: deploy.sh not found."
fi

log "System configured cleanly. Check log: $LOG_FILE"
