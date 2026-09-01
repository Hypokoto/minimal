#!/usr/bin/env bash
# minimal install.sh — idempotent, non-interactive shell environment installer.
# By default, installs ONLY Tier 0 (Core) and Tier 1 (CLI) official Arch packages.
# Usage: ./install.sh [OPTIONS]
# Options:
#   --all               Install all package tiers (Core, CLI, Dev, Network, Optional, AUR)
#   --with-dev          Install Tier 2 Development tools (Official)
#   --with-network      Install Tier 2 Network tools (Official)
#   --with-optional     Install Tier 2 Optional CLI tools (Official)
#   --with-aur          Install AUR packages (swayosd-git, jmtpfs, etc.)
#   --with-chaotic-aur  Explicitly consent to adding the third-party Chaotic-AUR repository
#   --dry-run           Print operations without modifying filesystem or system state
#   --help              Show this help message

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCH="$(uname -m)"

# --- Parse Arguments ---
INSTALL_DEV=false
INSTALL_NET=false
INSTALL_OPT=false
INSTALL_AUR=false
WITH_CHAOTIC_AUR=false
DRY_RUN=false

for arg in "$@"; do
    case $arg in
        --all) INSTALL_DEV=true; INSTALL_NET=true; INSTALL_OPT=true; INSTALL_AUR=true ;;
        --with-dev) INSTALL_DEV=true ;;
        --with-network) INSTALL_NET=true ;;
        --with-optional) INSTALL_OPT=true ;;
        --with-aur) INSTALL_AUR=true ;;
        --with-chaotic-aur) WITH_CHAOTIC_AUR=true ;;
        --dry-run) DRY_RUN=true ;;
        --help)
            awk '/^# Usage:/,/^$/' "$0" | sed 's/^# *//'
            exit 0
            ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

# Initialize logging cleanly: dry-run performs ZERO filesystem mutations
if [[ "$DRY_RUN" == false ]]; then
    STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
    mkdir -p "$STATE_DIR"
    LOG_FILE="$STATE_DIR/minimal-install.log"
else
    LOG_FILE=""
fi

log() {
    if [[ "$DRY_RUN" == true ]]; then
        printf '[DRY RUN] [%s] %s\n' "$(date '+%H:%M:%S')" "$1"
    else
        printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"
    fi
}

die()  { log "FATAL: $1"; exit 1; }

run_cmd() {
    if [[ "$DRY_RUN" == true ]]; then
        log "Would execute: $*"
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

    # --- Supply-Chain: Chaotic AUR ---
    if [[ "$WITH_CHAOTIC_AUR" == true ]]; then
        log "WARNING: Adding third-party Chaotic-AUR repository (explicit consent provided)."
        if ! grep -q "\\[chaotic-aur\\]" /etc/pacman.conf 2>/dev/null; then
            run_cmd sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
            run_cmd sudo pacman-key --lsign-key 3056513887B78AEB
            run_cmd sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
            if [[ "$DRY_RUN" == false ]]; then
                echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
            fi
        fi
        run_cmd sudo pacman -Syu --noconfirm
    else
        log "Updating official repositories..."
        run_cmd sudo pacman -Syu --noconfirm
    fi

    # Read Package Lists
    read_pkgs() { grep -vE '^\s*#|^\s*$' "$SCRIPT_DIR/packages/$1.txt" || true; }
    
    OFFICIAL_PKGS=()
    AUR_PKGS=()

    mapfile -t core_pkgs < <(read_pkgs "core")
    mapfile -t cli_pkgs < <(read_pkgs "cli")
    OFFICIAL_PKGS+=("${core_pkgs[@]}" "${cli_pkgs[@]}")

    if [[ "$INSTALL_DEV" == true ]]; then
        mapfile -t dev_pkgs < <(read_pkgs "dev")
        OFFICIAL_PKGS+=("${dev_pkgs[@]}")
    fi
    if [[ "$INSTALL_NET" == true ]]; then
        mapfile -t net_pkgs < <(read_pkgs "network")
        OFFICIAL_PKGS+=("${net_pkgs[@]}")
    fi
    if [[ "$INSTALL_OPT" == true ]]; then
        mapfile -t opt_pkgs < <(read_pkgs "optional")
        OFFICIAL_PKGS+=("${opt_pkgs[@]}")
    fi

    if [[ "$INSTALL_AUR" == true ]]; then
        mapfile -t aur_pkgs < <(read_pkgs "aur")
        AUR_PKGS+=("${aur_pkgs[@]}")
    fi

    # 1. Install Official Repository Packages via pacman (No AUR helper needed)
    if [[ "${#OFFICIAL_PKGS[@]}" -gt 0 ]]; then
        log "Installing ${#OFFICIAL_PKGS[@]} official packages via pacman..."
        run_cmd sudo pacman -Syu --needed --noconfirm "${OFFICIAL_PKGS[@]}"
    fi

    # 2. Bootstrap AUR Helper ONLY if AUR packages are explicitly requested
    if [[ "${#AUR_PKGS[@]}" -gt 0 ]]; then
        if ! command -v yay >/dev/null 2>&1; then
            log "AUR packages requested but yay not found. Bootstrapping yay from official AUR..."
            run_cmd sudo pacman -S --needed --noconfirm base-devel git
            if [[ "$DRY_RUN" == false ]]; then
                tmpdir="$(mktemp -d)"
                git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
                (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
                rm -rf "$tmpdir"
            else
                log "Would clone and build yay-bin."
            fi
        fi

        log "Installing ${#AUR_PKGS[@]} AUR packages via yay..."
        run_cmd yay -S --needed --noconfirm "${AUR_PKGS[@]}"
    else
        log "No AUR packages requested. Skipping AUR helper bootstrap."
    fi

    # --- Toolchain init (idempotent) ---
    if [[ "$INSTALL_DEV" == true ]] && ! rustup show >/dev/null 2>&1; then
      log "Initializing rustup default toolchain."
      run_cmd rustup default stable
    fi

    # Enable system services safely
    enable_service_if_exists() {
        if [[ "$DRY_RUN" == true ]]; then
            log "Would check and enable service: $1"
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
  if [[ "$DRY_RUN" == true ]]; then
    log "Would execute deploy.sh"
  else
    bash "$SCRIPT_DIR/deploy.sh"
  fi
else
  log "WARN: deploy.sh not found."
fi

if [[ "$DRY_RUN" == true ]]; then
    log "Dry run complete cleanly. Zero side effects on system or filesystem."
else
    log "System configured cleanly. Check log: $LOG_FILE"
fi
