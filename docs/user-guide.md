# Minimal OS Shell — User Guide

Welcome to **Minimal OS Shell**, an Arch Linux Hyprland desktop environment engineered for extreme speed (3ms Rust control plane execution), zero configuration drift, and low resource usage (<380MB idle RAM).

---

## 🚀 Quick Start & Daily Workflow

### 1. Application Launchers & Navigation
- **`SUPER + SPACE`**: Toggle Rofi App Launcher (search and open applications).
- **`ALT + Tab`**: Toggle Window Switcher overview.
- **`SUPER + SHIFT + Grave` (`~`)**: Toggle Control Center popup (Audio, Bluetooth, Network, Night Light, DND).
- **`SUPER + Escape`**: Toggle Power Overlay (`wlogout` bento power menu).
- **`SUPER + ALT + Escape`**: Lock screen (`hyprlock`).

### 2. Window Management & Spatial Navigation
- **`SUPER + Return`**: Launch Terminal (`kitty`).
- **`SUPER + Shift + Return`**: Launch Web Browser.
- **`SUPER + Q`**: Close active window.
- **`SUPER + V`**: Toggle floating mode for active window.
- **`SUPER + F`**: Toggle fullscreen mode.
- **`SUPER + H / J / K / L`**: Vim-style spatial focus navigation (Left / Down / Up / Right).
- **`SUPER + Shift + H / J / K / L`**: Move active window in direction.
- **`SUPER + Arrow Keys`**: Snap active window to screen halves.
- **`SUPER + ALT + Arrow Keys`**: Snap active window to screen quarters.
- **`SUPER + ALT + R`**: **Window Rescue** — emergency center-snaps misplaced or offscreen floating windows at 65% width/height.

### 3. Workspaces & Visual Task Overview (`hyprtasking`)
- **`SUPER + 1..9`**: Switch to virtual workspace 1 through 9.
- **`SUPER + Shift + 1..9`**: Move active window to workspace 1 through 9.
- **`SUPER + S`**: Toggle Special Scratchpad workspace.
- **`SUPER + T`** or **`SUPER + ~`**: Toggle `hyprtasking` visual Mission Control grid overview.
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
- **`SUPER + SHIFT + N`**: **Night Light Shader Toggle** — toggles 4500K warm compositor color temperature via `hyprsunset` (0MB RAM).
- **`SUPER + SHIFT + G`**: **Game Mode Toggle** — dynamically disables animations, blur, rounding, and shadows at runtime for maximum gaming FPS.
- **`SUPER + SHIFT + X`**: **Screen OCR Extractor** — snip any screen area (`slurp`), run Tesseract OCR, and copy extracted text to clipboard.
- **`SUPER + X`**: Toggle `cliphist` Clipboard History manager.
- **`SUPER + W`**: Toggle Wallpaper Picker.
- **`SUPER + N`**: Toggle Network menu.
- **`SUPER + C`**: Toggle Calendar popup.
- **`SUPER + E`**: Toggle Emoji picker.
- **`SUPER + B`**: Toggle Waybar visibility.

---

## 🎨 Theme System (`minimalctl`)

Minimal OS Shell uses a native Rust control plane (`minimalctl`) with `themes/*.toml` as the single source of truth for all desktop colors.

### Changing Themes
```bash
# List available themes
minimalctl theme list

# Hot-apply theme live across all 10 desktop targets
minimalctl theme apply obsidian

# Check currently active theme & content hash
minimalctl theme current

# Compare color tokens between two themes
minimalctl theme diff obsidian catppuccin

# Rollback to the previous theme state instantly
minimalctl theme rollback
```

---

## 🔧 System Diagnostics & Verification

```bash
# Verify zero configuration drift across all 10 compiled targets
minimalctl theme verify

# Verify directory structure and symlink integrity
minimalctl config verify

# Run operational health & security diagnostic suite
minimalctl doctor
```
