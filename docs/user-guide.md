# Minimal OS Shell — User Guide

Welcome to **Minimal OS Shell**, an Arch Linux Hyprland desktop environment engineered for extreme speed (native Rust control plane `minimalctl`), zero configuration drift, and low resource usage (<300MB idle RAM).

---

## 🚀 Quick Start & Daily Workflow

### 1. Application Launchers & Quickshell Overlays
- **`SUPER + SPACE`**: Toggle Quickshell App Grid Launcher (5-column grid launcher with freedesktop icon evaluation and right-click context menu).
- **`SUPER + X`**: Toggle Quickshell Clipboard History Manager (fuzzy search, text & image previews, single-item deletion, clear history).
- **`SUPER + N`**: Toggle Quickshell Control Center (Wi-Fi, Bluetooth, Audio, Brightness, Game Mode, Night Light, System Usage graphs).
- **`SUPER + Escape`**: Toggle Quickshell Power Menu Overlay (Shutdown, Reboot, Suspend, Lock, Logout).
- **`SUPER + ALT + Escape`**: Lock screen (`hyprlock`).
- **`SUPER + B`**: Toggle Quickshell Top Bar.

### 2. Window Management & Spatial Navigation
- **`SUPER + Return`**: Launch Terminal (`kitty`).
- **`SUPER + Q`**: Close active window.
- **`SUPER + F`**: Toggle fullscreen mode.
- **`SUPER + G`**: Toggle Hyprland window tabbed container grouping (`hy3`).
- **`SUPER + H / J / K / L`**: Vim-style spatial focus navigation (Left / Down / Up / Right).
- **`SUPER + Arrow Keys`**: Spatial window snap / tile in direction (Left / Right / Up / Down).
- **`SUPER + CTRL + H / J / K / L`** or **`SUPER + CTRL + Arrow Keys`**: Resize active window dimensions.
- **`SUPER + ALT + R`**: **Window Rescue** — emergency center-snaps misplaced or offscreen floating windows at 65% width/height.

### 3. Workspaces & Visual Task Overview (`hyprtasking`)
- **`SUPER + 1..9`**: Switch to virtual workspace 1 through 9.
- **`SUPER + Shift + 1..9`**: Move active window to workspace 1 through 9.
- **`SUPER + S`**: Toggle Special Scratchpad workspace.
- **`SUPER + T`**: Toggle `hyprtasking` visual 3x3 workspace grid overview.
- **`SUPER + TAB`**: Toggle cursor-focused overview.
- **`SUPER + SHIFT + Q`**: Kill hovered window inside overview.

#### 🖱️ Mouse & Touchpad Controls in Overview:
- **Left Click**: Select and switch focus directly to any window/workspace.
- **Left Click + Drag**: Drag-and-drop window thumbnails between workspaces in the grid.
- **4-Finger Swipe Up**: Open overview grid via touchpad.
- **4-Finger Swipe Down**: Exit overview.
- **3-Finger Swipe Left/Right**: Navigate between grid workspaces.
- **Escape** or **Click Empty Space**: Exit overview.

### 4. Utilities & Power Tools
- **`SUPER + SHIFT + N`**: **Night Light Shader Toggle** — toggles 4500K warm compositor color temperature via `hyprsunset`.
- **`SUPER + SHIFT + G`**: **Game Mode Toggle** — dynamically disables animations, blur, rounding, and shadows at runtime for maximum gaming FPS.
- **`SUPER + SHIFT + X`**: **Screen OCR Extractor** — snip any screen area (`slurp`), run Tesseract OCR, and copy extracted text to clipboard.

---

## 🎨 Theme System (`minimalctl`)

Minimal OS Shell uses a native Rust control plane (`minimalctl`) with `themes/*.toml` as the single source of truth for all desktop colors.

### Changing Themes
```bash
# List available themes
minimalctl theme list

# Hot-apply theme live across all 7 desktop targets live (Quickshell, Hyprland, Kitty, Tmux, Starship, btop, Neovim)
minimalctl theme apply obsidian

# Check currently active theme & content hash
minimalctl theme current

# Compare color tokens between two themes
minimalctl theme diff obsidian catppuccin

# Verify theme definition and target drift
minimalctl theme verify

# Run operational diagnostics suite
minimalctl doctor
```
