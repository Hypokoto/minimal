# Minimal — Keybindings Reference

A comprehensive cheat sheet for all global keyboard shortcuts and shell bindings configured in Minimal.

---

## 1. Hyprland Desktop Environment

The primary modifier key is **`SUPER`** (Windows key).

### Core Applications & Session
| Keybinding | Action |
| --- | --- |
| `SUPER + Return` | Launch Kitty terminal |
| `SUPER + Q` | Close active window |
| `SUPER + SHIFT + Q` | Kill active window (force) |
| `SUPER + SHIFT + E` | Exit Hyprland session |

### Window Controls & State
| Keybinding | Action |
| --- | --- |
| `SUPER + V` | Toggle floating window mode |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + F` | Toggle maximize (preserve bar) |
| `SUPER + M` | Minimize window to tray |
| `SUPER + SHIFT + M` | Restore / view minimized tray |
| `SUPER + P` | Pin window (always on top) |
| `SUPER + ALT + C` | Center floating window |
| `SUPER + ALT + R` | **Universal Window Recovery** (center, float 65%, reset to active workspace) |

### Spatial Window Snapping (Windows-Style Snap Layouts)
| Keybinding | Action |
| --- | --- |
| `SUPER + Left` | Snap half-screen left (50%) |
| `SUPER + Right` | Snap half-screen right (50%) |
| `SUPER + Up` | Snap half-screen top (50%) |
| `SUPER + Down` | Snap half-screen bottom (50%) |
| `SUPER + ALT + Left` | Snap quarter-screen top-left (50% x 50%) |
| `SUPER + ALT + Right` | Snap quarter-screen top-right (50% x 50%) |
| `SUPER + ALT + Up` | Snap quarter-screen bottom-left (50% x 50%) |
| `SUPER + ALT + Down` | Snap quarter-screen bottom-right (50% x 50%) |

### Window Grouping & Tabbing
| Keybinding | Action |
| --- | --- |
| `SUPER + G` | Toggle group / tab mode |
| `SUPER + ALT + Period` | Next tab in group |
| `SUPER + ALT + Comma` | Previous tab in group |

### Spatial Focus Navigation (Vim-style)
| Keybinding | Action |
| --- | --- |
| `SUPER + H / J / K / L` | Focus window left / down / up / right |
| `SUPER + ]` | Focus next monitor |
| `SUPER + [` | Focus previous monitor |

### Window Positioning & Swapping
| Keybinding | Action |
| --- | --- |
| `SUPER + SHIFT + H / J / K / L` | Move window left / down / up / right |
| `SUPER + ALT + H / J / K / L` | Swap window left / down / up / right |
| `SUPER + SHIFT + ]` | Move window to next monitor |
| `SUPER + SHIFT + [` | Move window to previous monitor |

### Interactive Resizing
| Keybinding | Action |
| --- | --- |
| `SUPER + CTRL + H / J / K / L` | Resize window (repeating, 40px step) |
| `SUPER + Left Click (Drag)` | Move window |
| `SUPER + Right Click (Drag)` | Resize window |

### Workspaces & Spaces Navigation (macOS-Style)
| Keybinding | Action |
| --- | --- |
| `SUPER + CTRL + Left / Right` | Relative workspace navigation (previous / next) |
| `SUPER + SHIFT + Up / Down` | Relocate window to relative workspace (up / down) |
| `SUPER + 1..9` | Focus workspace 1–9 |
| `SUPER + 0` | Focus workspace 10 |
| `SUPER + SHIFT + 1..9` | Move window to workspace 1–9 |
| `SUPER + SHIFT + 0` | Move window to workspace 10 |
| `SUPER + CTRL + 1..9` | Move window to workspace and follow |
| `SUPER + Tab` | Switch to previous workspace |
| `SUPER + Mouse Wheel` | Scroll workspaces |

### Scratchpads & Overlays
| Keybinding | Action |
| --- | --- |
| `SUPER + S` | Toggle scratchpad workspace |
| `SUPER + T` / `SUPER + ~` | Toggle task switcher grid overview (`hyprtasking`) |
| `SUPER + TAB` | Toggle cursor overview (`hyprtasking`) |
| `SUPER + SHIFT + Q` | Kill hovered window in overview (`hyprtasking`) |
| `Escape` | Exit overview (`hyprtasking`) |
| `SUPER + SHIFT + ~` | Open Rofi control center |
| `SUPER + B` | Toggle Waybar |
| `SUPER + Space` | Open Rofi application launcher |
| `ALT + Tab` | Rofi window switcher |
| `SUPER + Escape` | Open power menu overlay (`wlogout`) |
| `SUPER + ALT + Escape` | Lock screen (`hyprlock`) |

### Rofi Menus & System Scripts
| Keybinding | Action |
| --- | --- |
| `SUPER + SHIFT + B` | Battery status menu |
| `SUPER + C` | Calendar widget |
| `SUPER + E` | Emoji picker |
| `SUPER + N` | Network connection manager |
| `SUPER + X` | Clipboard history |
| `SUPER + W` | Wallpaper selector |
| `SUPER + A` | Audio output toggle |
| `SUPER + SHIFT + G` | **Game Mode Toggle** (disable animations, blur & shadows for max FPS) |
| `SUPER + SHIFT + X` | **Screen OCR Text Extractor** (snip region & copy text to clipboard) |
| `SUPER + SHIFT + N` | **Night Light Shader Toggle** (`hyprsunset` 4500K warm shader) |
| `SUPER + Escape` | **Power Menu Overlay** (`wlogout`) |

### Screenshots
| Keybinding | Action |
| --- | --- |
| `Print` | Capture full screen to clipboard |
| `SHIFT + Print` | Capture selected area to clipboard |
| `CTRL + Print` | Capture selected area and save to `~/Pictures/Screenshots/` |

### Media & Hardware Keys
| Keybinding | Action |
| --- | --- |
| `XF86AudioPlay` | Play / Pause media playback |
| `XF86AudioNext` | Next media track |
| `XF86AudioPrev` | Previous media track |
| `XF86AudioRaiseVolume` | Volume Up + OSD |
| `XF86AudioLowerVolume` | Volume Down + OSD |
| `XF86AudioMute` | Toggle Audio Mute + OSD |
| `XF86AudioMicMute` | Toggle Microphone Mute |
| `XF86MonBrightnessUp` | Screen Brightness Up + OSD |
| `XF86MonBrightnessDown` | Screen Brightness Down + OSD |

---

## 2. Zsh Shell & AI Helper

### Interactive Shortcuts & AI Integration
| Keybinding | Action |
| --- | --- |
| `Alt + E` / `Ctrl + G` | **AI Shell Helper**: Translate buffer or interactive natural language request into a Zsh command |
| `Up` / `Down` | History search matching typed command prefix |
| `Ctrl + P` / `Ctrl + N` | History search matching typed command prefix |
| `Ctrl + F` | Forward one word |
| `Ctrl + B` | Execute `ff` file finder shortcut |
| `Ctrl + H` | Delete previous word |
| `Home` / `End` | Jump to beginning / end of command line |
| `Tab` / `Shift + Tab` | Navigate autocompletion menu (`fzf-tab`) |

---

## 3. Tmux Terminal Multiplexer

The primary prefix key is **`Ctrl + A`**.

### Pane Splitting & Window Management
| Keybinding | Action |
| --- | --- |
| `Ctrl + A, r` | Reload `tmux.conf` configuration |
| `Ctrl + A, \|` or `v` | Split pane vertically (inherits working directory) |
| `Ctrl + A, -` or `_` | Split pane horizontally (inherits working directory) |
| `Ctrl + A, c` | Create new window in current path |
| `Alt + H / J / K / L` | Direct pane navigation (Left / Down / Up / Right) without prefix |
| `Ctrl + A, h / j / k / l` | Pane navigation fallback |
| `Ctrl + A, H / J / K / L` | Resize pane (5 cells Left / Down / Up / Right) |
| `Ctrl + A, m` | Toggle pane zoom (maximize/unmaximize) |
| `Ctrl + A, =` / `+` | Evenly balance panes horizontally / vertically |

### Rescue Shortcuts
| Keybinding | Action |
| --- | --- |
| `Ctrl + A, Ctrl + K` | **Soft Rescue**: Cancel copy mode and clear screen |
| `Ctrl + A, X` | **Hard Rescue**: Reset alternate screen buffer (recovers garbled TUIs) |
| `Alt + Escape` | Force exit from any special mode |

### Vi Copy Mode
| Keybinding | Action |
| --- | --- |
| `v` | Begin text selection |
| `y` | Copy selection to system clipboard and exit copy mode |
| `Escape` or `q` | Cancel copy mode |

---

## 4. Neovim (NvChad Starter Overlay)

The leader key is **`Space`**.

| Keybinding | Action |
| --- | --- |
| `<leader> e` | Toggle / focus NvimTree file explorer |
