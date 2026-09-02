# Minimal OS Shell — Technical Architecture

```mermaid
graph TD
    subgraph Single Source of Truth
        TOML["themes/*.toml (Obsidian / Catppuccin Design Tokens)"]
    end

    subgraph Native Rust Control Plane (minimalctl)
        COMPILER["Theme Compiler (3ms execution)"]
        ATOMIC["Atomic Write Pipeline (.tmp -> fsync -> rename)"]
        DRIFT["FNV-1a Zero-Drift Hash Engine"]
        ROLLBACK["Transactional State Rollback Machine"]
    end

    subgraph Target Applications (Live Retint)
        HYPR["hypr/colors.conf"]
        WB["waybar/style.css"]
        RF["rofi/theme.rasi"]
        BTOP["btop/btop.theme"]
        KITTY["kitty/kitty.conf"]
        MAKO["mako/config"]
        STAR["starship/starship.toml"]
        TMUX["tmux/tmux.conf"]
        NVIM["nvim/lua/themes/minimal.lua"]
        WLOG["wlogout/style.css"]
    end

    TOML --> COMPILER
    COMPILER --> ATOMIC
    COMPILER --> DRIFT
    COMPILER --> ROLLBACK
    ATOMIC --> HYPR
    ATOMIC --> WB
    ATOMIC --> RF
    ATOMIC --> BTOP
    ATOMIC --> KITTY
    ATOMIC --> MAKO
    ATOMIC --> STAR
    ATOMIC --> TMUX
    ATOMIC --> NVIM
    ATOMIC --> WLOG
```

---

## 🎯 Architecture Guiding Principles

1. **Single Source of Truth**: All colors and visual styles originate from `themes/*.toml`. No generated file contains hardcoded hex values.
2. **Atomic Write Pipeline**: File updates use a temporary file write (`.tmp`), an explicit disk sync (`fsync`), and atomic file replacement (`fs::rename`) to prevent corruption during crash or power loss.
3. **Zero-Drift Integrity**: Every theme build generates an FNV-1a content hash. Running `minimalctl theme verify` compares source tokens against compiled targets to catch manual edits instantly.
4. **Zero Bloat Daemons**: Uses lightweight Wayland components (Waybar, Mako, Rofi, SwayOSD) running at **<380MB idle RAM**.
5. **Transactional Rollback**: `minimalctl theme apply` creates a snapshot backup of existing configurations before applying new files, enabling instant 1-command rollback via `minimalctl theme rollback`.
