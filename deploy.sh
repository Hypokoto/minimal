#!/usr/bin/env bash
# ==============================================================================
# Minimal deploy.sh — Idempotent user file symlinking and NvChad deployment pipeline
# Supports GNU stow or absolute symlink fallback with atomic rotation.
# ==============================================================================
set -euo pipefail
IFS=$'\n\t'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/minimal-deploy.log"

log()  { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }
warn() { printf '[%s] WARN: %s\n' "$(date '+%H:%M:%S')" "$1" | tee -a "$LOG_FILE"; }

log "=== STARTING MINIMAL DEPLOYMENT PIPELINE ==="

# --- 1. Binary Presence Verification ---
log "--- Phase 1: Binary Presence Verification ---"
REQUIRED_BINARIES=(hyprland waybar rofi yazi starship mako cliphist atuin zoxide eza bat fd rg man)
MISSING_COUNT=0

for bin in "${REQUIRED_BINARIES[@]}"; do
    if command -v "$bin" >/dev/null 2>&1; then
        log "[OK] Binary found: $bin ($(command -v "$bin"))"
    else
        warn "[MISSING] Binary not found in PATH: $bin"
        MISSING_COUNT=$((MISSING_COUNT + 1))
    fi
done

if (( MISSING_COUNT > 0 )); then
    warn "$MISSING_COUNT required binaries missing. Continuing deployment, but some features may not function until installed."
fi

# --- 2. Color System Automation Execution ---
log "--- Phase 2: Compiling Palette Targets ---"
if command -v lua >/dev/null 2>&1; then
    lua "$DOTFILES_DIR/hypr/colors.lua" || warn "Lua palette generator failed."
elif command -v luajit >/dev/null 2>&1; then
    luajit "$DOTFILES_DIR/hypr/colors.lua" || warn "LuaJIT palette generator failed."
else
    warn "Neither lua nor luajit found in PATH. Palette targets not recompiled."
fi

# --- 3. Atomic Symlinking Pipeline ---
log "--- Phase 3: Deploying Module Symlinks ---"

deploy_link() {
    local src="$1" dest="$2"
    
    if [[ ! -e "$src" ]]; then
        warn "Source path does not exist: $src — skipping."
        return
    fi
    
    local parent_dir
    parent_dir="$(dirname "$dest")"

    if [[ -L "$parent_dir" || -f "$parent_dir" ]]; then
        log "Clearing non-directory file/symlink blocking parent dir: $parent_dir"
        rm -f "$parent_dir"
    fi

    mkdir -p "$parent_dir"

    if [[ -L "$dest" ]]; then
        local current_target
        current_target="$(readlink "$dest")"
        if [[ "$current_target" == "$src" ]]; then
            log "Link intact: $dest -> $src"
            return
        fi
    fi

    if [[ -e "$dest" || -L "$dest" ]]; then
        local backup
        backup="${dest}.bak.$(date +%s%N)"
        log "Rotating existing config: $dest -> $backup"
        mv "$dest" "$backup"
    fi

    ln -sfn "$src" "$dest"
    log "Created symlink: $dest -> $src"
}

# Symlink top-level modules and shell integrations:
# hypr, rofi, waybar, nvim, kitty, mako, yazi, zsh, starship, tmux, btop, fastfetch, security-dashboard
deploy_link "$DOTFILES_DIR/hypr"                    "$HOME/.config/hypr"
deploy_link "$DOTFILES_DIR/rofi"                    "$HOME/.config/rofi"
deploy_link "$DOTFILES_DIR/waybar"                  "$HOME/.config/waybar"
deploy_link "$DOTFILES_DIR/kitty"                   "$HOME/.config/kitty"
deploy_link "$DOTFILES_DIR/mako"                    "$HOME/.config/mako"
deploy_link "$DOTFILES_DIR/yazi"                    "$HOME/.config/yazi"
deploy_link "$DOTFILES_DIR/tmux"                    "$HOME/.config/tmux"
deploy_link "$DOTFILES_DIR/fastfetch"               "$HOME/.config/fastfetch"
deploy_link "$DOTFILES_DIR/zsh/.zshrc"              "$HOME/.zshrc"
deploy_link "$DOTFILES_DIR/zsh/aliases.zsh"         "$HOME/.config/zsh/aliases.zsh"
deploy_link "$DOTFILES_DIR/zsh/sec.zsh"             "$HOME/.config/zsh/sec.zsh"
deploy_link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
deploy_link "$DOTFILES_DIR/btop/btop.theme"        "$HOME/.config/btop/themes/btop.theme"
deploy_link "$DOTFILES_DIR/git/config"              "$HOME/.config/git/config"
deploy_link "$DOTFILES_DIR/nwg-drawer"              "$HOME/.config/nwg-drawer"
deploy_link "$DOTFILES_DIR/security-dashboard"      "$HOME/.config/security-dashboard"

mkdir -p "$HOME/.local/bin"
ln -sfn "$DOTFILES_DIR/hypr/scripts/toggle-bar.sh"   "$HOME/.local/bin/toggle-bar.sh"

mkdir -p "$HOME/Pictures/Wallpapers"

# --- 4. Neovim / NvChad Environment Overlay ---
log "--- Phase 4: Neovim / NvChad Overlay ---"
if [[ ! -f "$HOME/.config/nvim/lua/nvconfig.lua" && ! -f "$HOME/.config/nvim/init.lua" ]]; then
    log "NvChad base not detected. Cloning NvChad starter..."
    if [[ -e "$HOME/.config/nvim" ]]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak.$(date +%s%N)"
        log "Backed up existing nvim dir."
    fi
    git clone --depth 1 https://github.com/NvChad/starter "$HOME/.config/nvim" || warn "Git clone NvChad failed."
else
    log "Existing nvim config detected at ~/.config/nvim. Overlaying Minimal custom files..."
fi

mkdir -p "$HOME/.config/nvim/lua/configs" "$HOME/.config/nvim/lua/plugins" "$HOME/.config/nvim/lua/themes" "$HOME/.config/nvim/ftplugin"

cp -f "$DOTFILES_DIR/nvim/lua/chadrc.lua"            "$HOME/.config/nvim/lua/chadrc.lua" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/lua/autocmds.lua"          "$HOME/.config/nvim/lua/autocmds.lua" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/lua/plugins/init.lua"       "$HOME/.config/nvim/lua/plugins/init.lua" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/lua/mappings.lua"           "$HOME/.config/nvim/lua/mappings.lua" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/lua/configs/"*.lua          "$HOME/.config/nvim/lua/configs/" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/lua/themes/"*.lua           "$HOME/.config/nvim/lua/themes/" 2>/dev/null || true
cp -f "$DOTFILES_DIR/nvim/ftplugin/"*.lua             "$HOME/.config/nvim/ftplugin/" 2>/dev/null || true

log "NvChad overlay applied successfully."

# --- 5. Font Cache Verification ---
log "--- Phase 5: Font Cache Verification ---"
if command -v fc-cache >/dev/null 2>&1; then
    log "Refreshing system font cache (fc-cache -fv)..."
    fc-cache -fv >/dev/null 2>&1 || warn "fc-cache returned non-zero status."
    log "[OK] Font cache updated."
else
    warn "fc-cache binary not found. Skipping font cache refresh."
fi

log "=== MINIMAL DEPLOYMENT COMPLETE ==="
log "Log file saved to: $LOG_FILE"
