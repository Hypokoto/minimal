-- ==============================================================================
-- Minimal — Core Configuration (Lua, Hyprland 0.55+)
-- ==============================================================================
-- Ported 1:1 from your hyprland.conf. Split into files like the original's
-- `source =` lines, using require() (each file gets its own Lua scope, so an
-- error in one doesn't take down the rest — see wiki.hypr.land/Configuring/Start).
--
-- hypridle.conf and hyprlock.conf are UNCHANGED — those are separate binaries
-- (hypridle, hyprlock) that still use the old hyprlang syntax and are not
-- affected by this migration. Leave them exactly as they are.

-- --- Core System Sourcing ---
-- colors.lua replaces colors.conf (see that file's note — it wasn't actually
-- referenced by general{}/decoration{} in your original, just sourced+unused)
local colors = require("colors")
require("monitors")
require("keybinds")

-- --- Autostart Applications ---
-- exec-once → wrapped in the hyprland.start event so it only fires once at
-- boot, not on every config reload (Hyprland re-parses hyprland.lua on save).
hl.on("hyprland.start", function()
    hl.exec_cmd(os.getenv("HOME") .. "/.config/hypr/scripts/waybar-autohide.sh")
    hl.exec_cmd("mako")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 0.5 && " .. os.getenv("HOME") .. "/.config/hypr/wallpaper/restore.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- --- GPU Environment & Optimization (AMD iGPU Cezanne + RX 6500M dGPU) ---
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
-- Multi-GPU: Card2 is iGPU (eDP-1), Card1 is dGPU (HDMI-A-1). Passing both allows Hyprland to output to HDMI.
hl.env("WLR_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("VDPAU_DRIVER", "radeonsi")

-- --- Input Handling & Touchpad ---
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true, -- NOTE: hyphenated tap-to-click became underscored; verify key name
        },
    },
})

-- --- Touchpad Workspace Swipe Gestures (Hyprland 0.51+) ---
-- VERIFY: `gesture = 3, horizontal, workspace` is fairly new hyprlang syntax; the Lua
-- equivalent wasn't confirmed in current docs. Best-guess call below — check
-- wiki.hypr.land/Configuring/Variables (Gestures) or your LSP stubs for the real name.
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" }) -- VERIFY

-- --- Core Compositor Look & Feel ---
-- Default state: clean desktop (no gaps, no borders, no rounding).
-- When the bar is toggled on via SUPER+B, toggle-bar.sh applies
-- bento grid values (gaps_in=6, gaps_out=10, rounding=10, border_size=1).
hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        layout = "dwindle",
        allow_tearing = false,
        resize_on_border = true,
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        blur = {
            enabled = true,
            size = 4,
            passes = 2,
            vibrancy = 0.17,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 8,
            color = "rgba(0A0C1280)",
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
})

-- --- Layout-Specific Behaviors ---
-- CRITICAL v0.55 FIX (carried over): pseudotile isn't a dwindle key anymore.
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
        mfact = 0.55,
    },
})

-- --- Animations (Apple-Design Fluid Interface) ---
-- Replaced default bezier with a critically damped, Apple-inspired spring approximation.
-- This curve (0.05, 0.9, 0.1, 1.0) mimics a responsive, non-overshooting physical spring.
hl.curve("apple_fluid", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "apple_fluid", style = "popin 90%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "apple_fluid" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "apple_fluid", style = "slide" })
hl.animation({ leaf = "border",     enabled = true, speed = 6, bezier = "apple_fluid" })

-- ==============================================================================
-- Window Rules
-- ==============================================================================
-- match.class/match.title keep the same regex strings as your original
-- windowrule blocks. Field names (class/title/float/move/size) are confirmed
-- via wiki.hypr.land/Configuring/Basics/Window-Rules for the general shape;
-- double-check any that fail silently against your LSP stubs.

hl.window_rule({ name = "nvim-workspace-1", match = { class = "^(nvim)$" }, workspace = "1" })

hl.window_rule({
    name = "nvchad-kitty-workspace-1",
    match = { class = "^(kitty)$", title = "^(nvchad)$" },
    workspace = "1",
})

hl.window_rule({
    name = "neotree-float-class",
    match = { class = "^(neo-tree)$" },
    float = true,
    move = "75% 0%",
    size = "25% 100%",
})

hl.window_rule({
    name = "neotree-float-title",
    match = { title = "^(neo-tree)$" },
    float = true,
    move = "75% 0%",
    size = "25% 100%",
})

hl.window_rule({ name = "walker-float-center", match = { class = "^(walker)$" }, float = true, center = true, rounding = 12 })
hl.window_rule({ name = "nm-editor-float", match = { class = "^(nm-connection-editor)$" }, float = true, rounding = 12 })
hl.window_rule({ name = "pavucontrol-float", match = { class = "^(pavucontrol)$" }, float = true, center = true, rounding = 12 })
hl.window_rule({ name = "rofi-center", match = { class = "^(Rofi)$" }, float = true, center = true })
hl.window_rule({
    name = "polkit-agent",
    match = { class = "^(polkit-gnome-authentication-agent-1)$" },
    float = true,
    rounding = 12,
})
