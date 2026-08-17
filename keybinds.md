# Minimal — Keybindings Reference

A comprehensive cheat sheet for all global keyboard shortcuts and shell bindings configured in Minimal.

---

## 1. Hyprland Desktop Environment

The primary modifier key is **`SUPER`** (Windows key).

### Window & Session Management
| Keybinding | Action |
| --- | --- |
| `SUPER + Return` | Launch Kitty terminal |
| `SUPER + Q` | Close active window |
| `SUPER + SHIFT + E` | Exit Hyprland session |
| `SUPER + Space` | Open Rofi application launcher |
| `SUPER + V` | Toggle floating window mode |
| `SUPER + F` | Toggle fullscreen mode |
| `SUPER + P` / `SUPER + T` | Toggle pseudo-tiling mode |
| `SUPER + Left Click (Drag)` | Move window |
| `SUPER + Right Click (Drag)` | Resize window |

### Navigation & Focus (Vim-style)
| Keybinding | Action |
| --- | --- |
| `SUPER + H` | Focus window left |
| `SUPER + J` | Focus window down |
| `SUPER + K` | Focus window up |
| `SUPER + L` | Focus window right |

### Workspaces
| Keybinding | Action |
| --- | --- |
| `SUPER + 1..5` | Switch to workspace 1–5 |
| `SUPER + SHIFT + 1..5` | Move window to workspace 1–5 |
| `SUPER + Tab` | Switch to previous active workspace |
| `SUPER + Mouse Wheel Down` | Switch to next workspace |
| `SUPER + Mouse Wheel Up` | Switch to previous workspace |

### Rofi Menus & System Scripts
| Keybinding | Action |
| --- | --- |
| `SUPER + Escape` | Open Power Menu (`powermenu.sh`) |
| `SUPER + SHIFT + L` | Lock screen (`hyprlock`) |
| `SUPER + B` | Toggle Waybar visibility (`waybar-toggle.sh`) |
| `SUPER + SHIFT + B` | Open Battery status menu (`battery.sh`) |
| `SUPER + C` | Open Calendar widget (`calendar.sh`) |
| `SUPER + E` | Open Emoji picker (`emoji.sh`) |
| `SUPER + N` | Open Network connection manager (`network.sh`) |
| `SUPER + X` | Open Clipboard history (`clipboard.sh`) |
| `SUPER + W` | Open Wallpaper selector (`picker.sh`) |

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
| `XF86AudioRaiseVolume` | Volume Up (+5%) + OSD |
| `XF86AudioLowerVolume` | Volume Down (-5%) + OSD |
| `XF86AudioMute` | Toggle Audio Mute + OSD |
| `XF86AudioMicMute` | Toggle Microphone Mute |
| `XF86MonBrightnessUp` | Screen Brightness Up (+5%) + OSD |
| `XF86MonBrightnessDown` | Screen Brightness Down (-5%) + OSD |

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
|| `<leader> e` | Toggle / focus NvimTree file explorer |
