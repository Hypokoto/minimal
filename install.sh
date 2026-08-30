#!/usr/bin/env bash
# minimal install.sh — idempotent, non-interactive.
# Installs core utilities, toolchains, system packages, and core systemd layers.
# Arch Linux is the primary target. On other distros the script warns and skips
# package installation but still deploys dotfiles via deploy.sh.
set -euo pipefail
IFS=$'\n\t'

LOG_FILE="/tmp/minimal-install.log"
ARCH="$(uname -m)"

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
die()  { log "FATAL: $1"; exit 1; }

[[ "$ARCH" == "x86_64" ]] || die "Untested arch: $ARCH. Aborting — do not assume compatibility."

log "=== STARTING SYSTEM INSTALLATION ==="

# --- Distro Detection ---
PKG_MGR=""
if command -v pacman >/dev/null 2>&1; then
    PKG_MGR="pacman"
elif command -v apt-get >/dev/null 2>&1; then
    PKG_MGR="apt"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MGR="dnf"
elif command -v brew >/dev/null 2>&1; then
    PKG_MGR="brew"
else
    log "WARN: No supported package manager found (pacman/apt/dnf/brew)."
    log "Skipping system package installation. Only dotfile deployment will run."
fi

# --- Arch-only: AUR helper + system packages ---
if [[ "$PKG_MGR" == "pacman" ]]; then

    # --- AUR helper bootstrap (yay) ---
    if ! command -v yay >/dev/null 2>&1; then
      log "yay not found. Building from AUR."
      sudo pacman -S --needed --noconfirm base-devel git
      tmpdir="$(mktemp -d)"
      git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
      (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
      rm -rf "$tmpdir"
    else
      log "yay present. Skipping bootstrap."
    fi

    # --- Core package sets (Audited & Modernized) ---
    PACMAN_PKGS=(
      hyprland hyprpaper hypridle hyprlock xdg-desktop-portal-hyprland
      waybar mako kitty tmux zsh fzf ripgrep fd yazi btop
      neovim base-devel git rustup clang jdk-openjdk maven
      ttf-firacode-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji fastfetch
      networkmanager network-manager-applet power-profiles-daemon
      pipewire pipewire-pulse wireplumber playerctl
      polkit-gnome qt5-wayland qt6-wayland
      zsh-syntax-highlighting zsh-autosuggestions
      cliphist wl-clipboard grim slurp brightnessctl rofimoji
      starship git-delta duf dust atuin bottom yq trash-cli chafa eza zoxide bat zstd unrar bc
      gping trippy bind nmap iperf3 bandwhich speedtest-cli iftop nethogs doggo man-db man-pages \
      rustscan sniffnet netscanner hexyl cargo-audit \
      nwg-drawer
    )

    AUR_PKGS=(
      hyprlauncher
      jmtpfs
      swayosd-git
      scdoc
      ripdrag
      feroxbuster
    )

    log "Installing pacman package set (${#PACMAN_PKGS[@]} packages)."
    sudo pacman -Syu --needed --noconfirm "${PACMAN_PKGS[@]}" \
      || die "pacman install failed. Check $LOG_FILE, do not retry blindly — inspect the actual error."

    log "Installing AUR package set (${#AUR_PKGS[@]} packages)."
    yay -S --needed --noconfirm "${AUR_PKGS[@]}" \
      || log "WARN: one or more AUR packages failed. Non-fatal — continuing. Check log."

    # --- Toolchain init (idempotent) ---
    if ! rustup show >/dev/null 2>&1; then
      log "Initializing rustup default toolchain."
      rustup default stable
    else
      log "rustup already initialized. Skipping."
    fi

    # --- Enable system services ---
    sudo systemctl enable --now NetworkManager.service
    sudo systemctl enable --now power-profiles-daemon.service
    sudo systemctl enable --now swayosd-libinput-backend.service

    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service 2>/dev/null || \
      log "WARN: user pipewire services not enabled (no active user session in this shell — expected under sudo/chroot install)."

else
    log "Non-Arch system detected ($PKG_MGR). Skipping system package installation."
    log "Please install core packages manually, then run: bash deploy.sh"
fi

# --- Default shell change (idempotent, any distro) ---
ZSH_PATH="$(command -v zsh 2>/dev/null || true)"
if [[ -n "$ZSH_PATH" && "$SHELL" != "$ZSH_PATH" ]]; then
  log "Changing default shell to zsh: $ZSH_PATH"
  chsh -s "$ZSH_PATH" "$USER" || log "WARN: chsh failed — run manually: chsh -s $ZSH_PATH"
else
  if [[ -z "$ZSH_PATH" ]]; then
    log "WARN: zsh not installed. Skipping default shell change."
  else
    log "zsh already default shell. Skipping."
  fi
fi

# --- Deploy configuration files (always runs) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/deploy.sh" ]]; then
  log "Executing dotfile deployment via deploy.sh..."
  bash "$SCRIPT_DIR/deploy.sh"
else
  log "WARN: deploy.sh not found in $SCRIPT_DIR — skipping dotfile linking."
fi

log "System packages, toolchains, and dotfiles configured cleanly. Check log: $LOG_FILE"
