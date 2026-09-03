-- ==============================================================================
-- Minimal — Core Compositor Configuration (Lua, Hyprland 0.55+)
-- Single source of truth for compositor rules, inputs, decoration, and window placement.
-- ==============================================================================

-- --- Core System Sourcing ---
local colors = require("colors")
require("monitors")
require("keybinds")

-- --- Autostart Applications ---
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("hyprctl plugin unload /var/cache/hyprpm/hypokoto/hyprland-plugins/hyprbars.so 2>/dev/null || true")
    hl.exec_cmd("hyprctl plugin unload /var/cache/hyprpm/hypokoto/hyprland-plugins/borders-plus-plus.so 2>/dev/null || true")
    hl.exec_cmd("pgrep -x quickshell >/dev/null || quickshell --daemonize")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 0.5 && " .. os.getenv("HOME") .. "/.config/hypr/wallpaper/restore.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-- --- GPU Environment & Optimization ---
if os.rename("/dev/dri/card1", "/dev/dri/card1") and os.rename("/dev/dri/card2", "/dev/dri/card2") then
    hl.env("LIBVA_DRIVER_NAME", "radeonsi")
    hl.env("VDPAU_DRIVER", "radeonsi")
    hl.env("WLR_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
end

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- --- Input Handling & Touchpad Gestures ---
hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        mouse_refocus = false,
        off_window_axis_events = 2,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.7,
        },
    },
    gestures = {
        workspace_swipe_distance = 700,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true,
    },
    binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

-- Multi-touch Input Gestures
hl.gesture({ fingers = 3, direction = "swipe", action = "move" })
hl.gesture({ fingers = 3, direction = "pinch", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- --- Core Compositor Look & Feel ---
-- Bento layout with 12px rounding, subtle 1px borders, balanced gaps & edge snapping.
hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 10,
        gaps_workspaces = 50,
        border_size = 1,
        layout = "dwindle",
        allow_tearing = true, -- Enables `immediate` tearing window rules for gaming
        resize_on_border = true,
        hover_icon_on_border = true,
        ["col.active_border"] = "rgba(7DD3FCFF)",
        ["col.inactive_border"] = "rgba(19212DFF)",
        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true,
        },
    },
    decoration = {
        rounding = 12,
        active_opacity = 1.0,
        inactive_opacity = 0.96,
        dim_inactive = true,
        dim_strength = 0.05,
        dim_special = 0.2,
        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            vibrancy = 0.2,
            vibrancy_darkness = 0.5,
            new_optimizations = true,
            xray = true,
            special = false,
            popups = false,
            popups_ignorealpha = 0.6,
        },
        shadow = {
            enabled = true,
            range = 12,
            offset = { 0, 2 },
            render_power = 4,
            color = "rgba(0A0C1280)",
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        allow_session_lock_restore = true,
        session_lock_xray = true,
        initial_workspace_tracking = false,
    },
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false,
    },
})

-- ==============================================================================
-- Motion System (Bezier Motion System & Animation Curves)
-- ==============================================================================
hl.curve("expressiveFastSpatial",    { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.90 } } })
hl.curve("expressiveSlowSpatial",    { type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.00 } } })
hl.curve("emphasizedDecel",          { type = "bezier", points = { { 0.05, 0.70 }, { 0.10, 1.00 } } })
hl.curve("emphasizedAccel",          { type = "bezier", points = { { 0.30, 0.00 }, { 0.80, 0.15 } } })
hl.curve("standardDecel",            { type = "bezier", points = { { 0.00, 0.00 }, { 0.00, 1.00 } } })
hl.curve("menu_decel",               { type = "bezier", points = { { 0.10, 1.00 }, { 0.00, 1.00 } } })
hl.curve("menu_accel",               { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })
hl.curve("stall",                    { type = "bezier", points = { { 1.00, -0.1 }, { 0.70, 0.85 } } })
hl.curve("apple_fluid",              { type = "bezier", points = { { 0.05, 0.90 }, { 0.10, 1.00 } } })

-- Leaf-specific Motion Bindings
hl.animation({ leaf = "windowsIn",          enabled = true, speed = 3,   bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",         enabled = true, speed = 2,   bezier = "emphasizedDecel", style = "popin 90%" })
hl.animation({ leaf = "windowsMove",        enabled = true, speed = 3,   bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "fadeIn",             enabled = true, speed = 3,   bezier = "emphasizedDecel" })
hl.animation({ leaf = "fadeOut",            enabled = true, speed = 2,   bezier = "emphasizedDecel" })
hl.animation({ leaf = "border",             enabled = true, speed = 8,   bezier = "emphasizedDecel" })
hl.animation({ leaf = "layersIn",           enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut",          enabled = true, speed = 2.4, bezier = "menu_accel",       style = "popin 94%" })
hl.animation({ leaf = "fadeLayersIn",       enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",      enabled = true, speed = 2.7, bezier = "stall" })
hl.animation({ leaf = "workspaces",         enabled = true, speed = 6,   bezier = "menu_decel",       style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })
hl.animation({ leaf = "zoomFactor",          enabled = true, speed = 3,   bezier = "standardDecel" })

-- ==============================================================================
-- Semantic Window Rules Hierarchy
-- ==============================================================================

-- 01 - Core Application Workspaces
hl.window_rule({ name = "nvim-workspace-1",    match = { class = "^(nvim)$" }, workspace = "1" })
hl.window_rule({ name = "nvchad-workspace-1",  match = { class = "^(kitty)$", title = "^(nvchad)$" }, workspace = "1" })

-- 02 - System & Polkit Authentication Dialogs
hl.window_rule({
    name = "polkit-agent",
    match = { class = "^(polkit-gnome-authentication-agent-1)$" },
    float = true,
    center = true,
    rounding = 12,
})

-- 03 - System Utilities & Network Managers
hl.window_rule({ name = "nm-editor-float", match = { class = "^(nm-connection-editor)$" }, float = true, center = true, size = { "(monitor_w*0.45)", "(monitor_h*0.45)" }, rounding = 12 })
hl.window_rule({ name = "blueman-float",   match = { class = "^(.blueman-manager-wrapped|blueman-manager)$" }, float = true, center = true, size = { "(monitor_w*0.45)", "(monitor_h*0.45)" }, rounding = 12 })
hl.window_rule({ name = "pavucontrol-float", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" }, float = true, center = true, size = { "(monitor_w*0.45)", "(monitor_h*0.45)" }, rounding = 12 })

-- 04 - XDG Desktop Portal & File Pickers
hl.window_rule({ name = "portal-filepicker",     match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true, center = true, rounding = 12 })
hl.window_rule({ name = "portal-kde-filepicker", match = { class = "^(xdg-desktop-portal-kde|org.freedesktop.impl.portal.desktop.kde)$" }, float = true, center = true, size = { "(monitor_w*0.60)", "(monitor_h*0.65)" }, rounding = 12 })

-- 05 - File Dialogs & File Pickers
hl.window_rule({
    name = "general-file-picker",
    match = { title = "^(Open File|Select a File|Choose wallpaper|Open Folder|Save As|Library|File Upload|Choose Files)(.*)$" },
    float = true,
    center = true,
    rounding = 12,
})
hl.window_rule({
    name = "file-picker-intent",
    match = { title = "^(.*)(wants to save|wants to open)$" },
    float = true,
    center = true,
    rounding = 12,
})

-- 06 - Launchers & Rofi Menus
hl.window_rule({ name = "rofi-center",         match = { class = "^(Rofi)$" }, float = true, center = true })
hl.window_rule({ name = "walker-float-center", match = { class = "^(walker)$" }, float = true, center = true, rounding = 12 })

-- 07 - Media & Picture-in-Picture Overlay
hl.window_rule({
    name = "picture-in-picture",
    match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float = true,
    pin = true,
    keep_aspect_ratio = true,
    move = { "(monitor_w*0.73)", "(monitor_h*0.72)" },
    size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
    rounding = 8,
})

-- 08 - Screen Sharing Indicator
hl.window_rule({
    name = "screen-sharing-indicator",
    match = { title = ".*is sharing (a window|your screen).*" },
    float = true,
    pin = true,
    move = { "(monitor_w*.5-window_w*.5)", "(monitor_h-window_h-12)" },
})

-- 09 - Tearing Rules (Low-latency gaming)
hl.window_rule({ name = "tearing-exe",       match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ name = "tearing-minecraft", match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ name = "tearing-steam",     match = { class = "^(steam_app).*" }, immediate = true })

-- 10 - Scratchpad Terminal
hl.window_rule({
    name = "scratchpad-terminal",
    match = { class = "^(kitty-scratchpad)$" },
    float = true,
    center = true,
    size = { "60%", "50%" },
    workspace = "special:scratchpad",
})

-- 11 - Sidebars & File Trees
hl.window_rule({
    name = "neotree-float-class",
    match = { class = "^(neo-tree)$" },
    float = true,
    move = { "75%", "0%" },
    size = { "25%", "100%" },
})

-- 12 - Floating Utility Tools & Hardware Diagnostics
hl.window_rule({ name = "calculator-float", match = { class = "^(gnome-calculator|kcalc|qalculate-gtk)$" }, float = true, center = true, rounding = 12 })
hl.window_rule({ name = "hyprpicker-float", match = { class = "^(hyprpicker)$" }, float = true, center = true })
hl.window_rule({ name = "guifetch-float",   match = { class = "^(guifetch)$" }, float = true, center = true })

-- 13 - Tiled Shadows Guard
hl.window_rule({ name = "tiled-no-shadow", match = { float = 0 }, no_shadow = true })

-- ==============================================================================
-- Layer Rules Architecture (Blur, Alpha & Animation Controls)
-- ==============================================================================
hl.layer_rule({ name = "global-xray",           match = { namespace = ".*" }, xray = true })

-- Fast/Instant Overlays (No animation delay for utility layers)
hl.layer_rule({ name = "walker-noanim",        match = { namespace = "walker" }, no_anim = true })
hl.layer_rule({ name = "selection-noanim",     match = { namespace = "selection" }, no_anim = true })
hl.layer_rule({ name = "overview-noanim",      match = { namespace = "overview" }, no_anim = true })
hl.layer_rule({ name = "anyrun-noanim",        match = { namespace = "anyrun" }, no_anim = true })
hl.layer_rule({ name = "hyprpicker-noanim",    match = { namespace = "hyprpicker" }, no_anim = true })
hl.layer_rule({ name = "indicator-noanim",     match = { namespace = "indicator.*" }, no_anim = true })

-- Blur & Transparency Policies for Quickshell Presentation Layer
hl.layer_rule({ name = "quickshell-blur",        match = { namespace = "quickshell.*" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "quickshell-launcher",    match = { namespace = "launcher" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "quickshell-notifications", match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.5 })
-- ==============================================================================
-- Hyprland Plugins Configuration (hyprtasking)
-- ==============================================================================
hl.config({
    plugin = {
        hyprtasking = {
            layout = "grid",
            gap_size = 4,
            bg_color = 0xff0b0e14,
            border_size = 3,
            exit_on_hovered = false,
            warp_on_move_window = 1,
            close_overview_on_reload = false,
            drag_button = 0x110,
            select_button = 0x110,
            jump = {
                enabled = false,
                label_color = 0xffffffff,
                label_background = 0x000000cc,
                label_size = 32,
            },
            gestures = {
                enabled = true,
                move_fingers = 3,
                move_distance = 300,
                open_fingers = 4,
                open_distance = 300,
                open_positive = true,
            },
            grid = {
                rows = 3,
                cols = 3,
                loop = false,
                layers = 1,
                loop_layers = false,
                gaps_use_aspect_ratio = true,
            },
            linear = {
                top = false,
                height = 400,
                scroll_speed = 1.0,
                blur = false,
            },
        },
    },
})


