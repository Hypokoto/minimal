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
#   --help              Show this help message

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/minimal-install.log"
ARCH="$(uname -m)"

# --- Parse Arguments ---
INSTALL_ALL=false
INSTALL_DEV=false
INSTALL_NET=false
INSTALL_OPT=false
WITH_CHAOTIC_AUR=false

for arg in "$@"; do
    case $arg in
        --all) INSTALL_ALL=true; INSTALL_DEV=true; INSTALL_NET=true; INSTALL_OPT=true ;;
        --with-dev) INSTALL_DEV=true ;;
        --with-network) INSTALL_NET=true ;;
        --with-optional) INSTALL_OPT=true ;;
        --with-chaotic-aur) WITH_CHAOTIC_AUR=true ;;
        --help)
            awk '/^# Usage:/,/^$/' "$0" | sed 's/^# *//'
            exit 0
            ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
die()  { log "FATAL: $1"; exit 1; }

[[ "$ARCH" == "x86_64" ]] || die "Untested arch: $ARCH. Aborting — do not assume compatibility."

log "=== STARTING SYSTEM INSTALLATION ==="

# --- Distro Detection ---
PKG_MGR=""
if command -v pacman >/dev/null 2>&1; then
    PKG_MGR="pacman"
else
    log "WARN: Arch Linux pacman not found."
    log "Skipping system package installation. Only dotfile deployment will run."
fi

# --- Arch-only: AUR helper + system packages ---
if [[ "$PKG_MGR" == "pacman" ]]; then

    # --- Supply-Chain: Chaotic AUR ---
    if [[ "$WITH_CHAOTIC_AUR" == true ]]; then
        log "WARNING: Adding third-party Chaotic-AUR repository (explicit consent provided)."
        if ! grep -q "\\[chaotic-aur\\]" /etc/pacman.conf; then
            sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com || true
            sudo pacman-key --lsign-key 3056513887B78AEB || true
            sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' || true
            echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf
        fi
        sudo pacman -Sy
    fi

    # --- Supply-Chain: AUR Bootstrap ---
    if ! command -v yay >/dev/null 2>&1; then
      log "yay not found. Building from official AUR."
      sudo pacman -S --needed --noconfirm base-devel git
      tmpdir="$(mktemp -d)"
      git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
      (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
      rm -rf "$tmpdir"
    fi

    # --- Read Package Lists ---
    # Strip comments and empty lines
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

    log "Installing ${#PKGS_TO_INSTALL[@]} packages using yay..."
    yay -S --needed --noconfirm "${PKGS_TO_INSTALL[@]}" \
      || die "Package installation failed. Check $LOG_FILE."

    # --- Toolchain init (idempotent) ---
    if [[ "$INSTALL_DEV" == true ]] && ! rustup show >/dev/null 2>&1; then
      log "Initializing rustup default toolchain."
      rustup default stable
    fi

    # --- Enable system services ---
    sudo systemctl enable --now NetworkManager.service
    sudo systemctl enable --now power-profiles-daemon.service
    sudo systemctl enable --now swayosd-libinput-backend.service 2>/dev/null || true

else
    log "Non-Arch system detected. Skipping package management."
fi

# --- Default shell change (idempotent, any distro) ---
ZSH_PATH="$(command -v zsh 2>/dev/null || true)"
if [[ -n "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
  log "Changing default shell to zsh: $ZSH_PATH"
  chsh -s "$ZSH_PATH" "$USER" || log "WARN: chsh failed — run manually: chsh -s $ZSH_PATH"
fi

# --- Deploy configuration files (always runs) ---
if [[ -f "$SCRIPT_DIR/deploy.sh" ]]; then
  log "Executing dotfile deployment via deploy.sh..."
  bash "$SCRIPT_DIR/deploy.sh"
else
  log "WARN: deploy.sh not found."
fi

log "System packages and dotfiles configured cleanly. Check log: $LOG_FILE"
