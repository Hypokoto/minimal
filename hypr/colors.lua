-- ==============================================================================
-- Minimal — Color System Compiler & Lua Export
-- Compatible with Lua 5.1 (LuaJIT) and Lua 5.4.
-- Reads palette.md as single source of truth and updates target configuration files.
-- ==============================================================================

local colors = {
    background = "rgba(0A0C12FF)",
    surface    = "rgba(11141DFF)",
    overlay    = "rgba(1C2230FF)",
    text       = "rgba(F2F6FFFF)",
    muted      = "rgba(8D95B3FF)",
    primary    = "rgba(00D9FFFF)",
    secondary  = "rgba(5B8CFFFF)",
    highlight  = "rgba(A05CFFFF)",
    success    = "rgba(4DFF91FF)",
    warning    = "rgba(FFCC66FF)",
    danger     = "rgba(FF5470FF)",
    info       = "rgba(61E6FFFF)",
}

local hex_colors = {
    background = "#0A0C12",
    surface    = "#11141D",
    overlay    = "#1C2230",
    text       = "#F2F6FF",
    muted      = "#8D95B3",
    primary    = "#00D9FF",
    secondary  = "#5B8CFF",
    highlight  = "#A05CFF",
    success    = "#4DFF91",
    warning    = "#FFCC66",
    danger     = "#FF5470",
    info       = "#61E6FF",
}

local function trim(s)
    if not s then return "" end
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function clean_token(s)
    s = trim(s)
    return (s:gsub("`", ""):gsub("#", ""))
end

local function find_palette_path()
    local paths = {
        "palette.md",
        "../palette.md",
        os.getenv("HOME") and (os.getenv("HOME") .. "/minimal/palette.md") or nil,
    }
    if arg and arg[0] then
        local dir = arg[0]:match("^(.*[/\\])")
        if dir then
            table.insert(paths, 1, dir .. "../palette.md")
            table.insert(paths, 1, dir .. "palette.md")
        end
    end
    for _, p in ipairs(paths) do
        if p then
            local f = io.open(p, "r")
            if f then
                f:close()
                return p
            end
        end
    end
    return nil
end

local function parse_palette(palette_path)
    local f = io.open(palette_path, "r")
    if not f then return end
    for line in f:lines() do
        if line:find("^|") and not line:find("|%s*Token") and not line:find("|%-%-") then
            local cols = {}
            for col in line:gmatch("[^|]+") do
                table.insert(cols, col)
            end
            if #cols >= 2 then
                local name = trim(cols[1]):lower()
                local hex_val = clean_token(cols[2])
                if #name > 0 and #hex_val == 6 then
                    hex_colors[name] = "#" .. hex_val:upper()
                    colors[name] = "rgba(" .. hex_val:upper() .. "FF)"
                end
            end
        end
    end
    f:close()
end

local function write_file(filepath, content)
    local f = io.open(filepath, "w")
    if f then
        f:write(content)
        f:close()
        print("[Minimal] Palette compiled target: " .. filepath)
    else
        print("[Minimal] WARN: Could not write target: " .. filepath)
    end
end

local function generate_targets(base_dir)
    base_dir = base_dir or "."

    -- 1. hypr/colors.conf
    local colors_conf = string.format([[# ==============================================================================
# Minimal — Hyprland Color Variables
# Generated from palette.md — DO NOT edit directly.
# To update colors, edit palette.md and regenerate.
# ==============================================================================

$background = %s
$surface    = %s
$overlay    = %s
$text       = %s
$muted      = %s
$primary    = %s
$secondary  = %s
$highlight  = %s
$success    = %s
$warning    = %s
$danger     = %s
$info       = %s
]],
        colors.background or "rgba(0A0C12FF)",
        colors.surface or "rgba(11141DFF)",
        colors.overlay or "rgba(1C2230FF)",
        colors.text or "rgba(F2F6FFFF)",
        colors.muted or "rgba(8D95B3FF)",
        colors.primary or "rgba(00D9FFFF)",
        colors.secondary or "rgba(5B8CFFFF)",
        colors.highlight or "rgba(A05CFFFF)",
        colors.success or "rgba(4DFF91FF)",
        colors.warning or "rgba(FFCC66FF)",
        colors.danger or "rgba(FF5470FF)",
        colors.info or "rgba(61E6FFFF)"
    )
    write_file(base_dir .. "/hypr/colors.conf", colors_conf)

    -- 2. rofi/theme.rasi
    local theme_rasi = string.format([[/**
 * theme.rasi — Emperor's Mirror centralized token palette
 * Generated from palette.md — DO NOT edit directly.
 */

* {
    bg:        %s;
    surface:   %s;
    overlay:   %s;
    fg:        %s;
    muted:     %s;
    primary:   %s;
    secondary: %s;
    highlight: %s;
    success:   %s;
    warning:   %s;
    danger:    %s;
    info:      %s;

    /* transparent variants for hover/alpha layering */
    bg-trans:      %sCC;
    overlay-trans: %sAA;

    font: "AdwaitaMono Nerd Font 11";

    background-color: transparent;
    text-color:        @fg;
    margin:  0px;
    padding: 0px;
    spacing: 0px;
}

window {
    background-color: @bg-trans;
    border:           2px;
    border-color:     @primary;
    border-radius:    12px;
}

element selected {
    background-color: @overlay;
    text-color:        @primary;
    border:            0px 0px 0px 2px;
    border-color:      @primary;
}

element normal {
    background-color: transparent;
    text-color:        @fg;
}
]],
        hex_colors.background, hex_colors.surface, hex_colors.overlay,
        hex_colors.text, hex_colors.muted, hex_colors.primary,
        hex_colors.secondary, hex_colors.highlight, hex_colors.success,
        hex_colors.warning, hex_colors.danger, hex_colors.info,
        hex_colors.background, hex_colors.overlay
    )
    write_file(base_dir .. "/rofi/theme.rasi", theme_rasi)

    -- 3. btop/btop.theme
    local btop_theme = string.format([[# btop tty theme
# Name: Minimal
# Generated from palette.md — DO NOT edit directly.

# Main UI Element Colors
theme[main_bg]="%s"
theme[main_fg]="%s"
theme[title]="%s"
theme[hi_fg]="%s"
theme[selected_bg]="%s"
theme[selected_fg]="%s"
theme[inactive_fg]="%s"
theme[graph_text]="%s"
theme[proc_misc]="%s"

# Box Outlines
theme[cpu_box]="%s"
theme[mem_box]="%s"
theme[net_box]="%s"
theme[proc_box]="%s"
theme[div_line]="%s"

# CPU Graph Colors
theme[cpu_start]="%s"
theme[cpu_mid]="%s"
theme[cpu_end]="%s"

# Temperature Colors
theme[temp_start]="%s"
theme[temp_mid]="%s"
theme[temp_end]="%s"

# Mem/Disk free meter
theme[free_start]="%s"
theme[free_mid]="%s"
theme[free_end]="%s"

# Mem/Disk cached meter
theme[cached_start]="%s"
theme[cached_mid]="%s"
theme[cached_end]="%s"

# Mem/Disk available meter
theme[available_start]="%s"
theme[available_mid]="%s"
theme[available_end]="%s"

# Mem/Disk used meter
theme[used_start]="%s"
theme[used_mid]="%s"
theme[used_end]="%s"

# Download graph colors
theme[download_start]="%s"
theme[download_mid]="%s"
theme[download_end]="%s"

# Upload graph colors
theme[upload_start]="%s"
theme[upload_mid]="%s"
theme[upload_end]="%s"
]],
        hex_colors.background, hex_colors.text, hex_colors.primary, hex_colors.primary,
        hex_colors.overlay, hex_colors.text, hex_colors.muted, hex_colors.muted, hex_colors.secondary,
        hex_colors.overlay, hex_colors.overlay, hex_colors.overlay, hex_colors.overlay, hex_colors.overlay,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.highlight, hex_colors.secondary, hex_colors.info,
        hex_colors.highlight, hex_colors.secondary, hex_colors.info
    )
    write_file(base_dir .. "/btop/btop.theme", btop_theme)

    -- 4. kitty/kitty.conf
    local kitty_conf = string.format([[# Minimal Kitty config
# Generated from palette.md — DO NOT edit directly.
font_family      AdwaitaMono Nerd Font
bold_font        auto
italic_font      auto
font_size        11.0

background_opacity 1.0
window_padding_width 10
confirm_os_window_close 0

cursor_shape beam
cursor_blink_interval 0

# --- Color mapping (palette.md) ---
foreground            %s
background            %s
selection_foreground  %s
selection_background  %s

cursor                %s
cursor_text_color     %s

url_color             %s

# black
color0  %s
color8  %s
# red
color1  %s
color9  %s
# green
color2  %s
color10 %s
# yellow
color3  %s
color11 %s
# blue
color4  %s
color12 %s
# magenta
color5  %s
color13 %s
# cyan
color6  %s
color14 %s
# white
color7  %s
color15 %s

active_border_color   %s
inactive_border_color %s
tab_bar_background    %s
active_tab_background %s
active_tab_foreground %s
inactive_tab_background %s
inactive_tab_foreground %s

allow_remote_control yes
enabled_layouts tall,fat,grid,stack
]],
        hex_colors.text, hex_colors.background, hex_colors.background, hex_colors.primary,
        hex_colors.primary, hex_colors.background, hex_colors.secondary,
        hex_colors.surface, hex_colors.muted,
        hex_colors.danger, hex_colors.danger,
        hex_colors.success, hex_colors.success,
        hex_colors.warning, hex_colors.warning,
        hex_colors.secondary, hex_colors.secondary,
        hex_colors.highlight, hex_colors.highlight,
        hex_colors.info, hex_colors.primary,
        hex_colors.text, hex_colors.text,
        hex_colors.primary, hex_colors.muted, hex_colors.surface,
        hex_colors.overlay, hex_colors.text, hex_colors.background, hex_colors.muted
    )
    write_file(base_dir .. "/kitty/kitty.conf", kitty_conf)

    -- 5. mako/config
    local mako_config = string.format([[# Minimal mako config
# Generated from palette.md — DO NOT edit directly.
# Requires mako >= 1.7 for progress-bar 'value' hint rendering

font=AdwaitaMono Nerd Font 10
background-color=%s
text-color=%s
border-color=%s
border-size=2
border-radius=10
padding=10
margin=8
width=320
height=100
default-timeout=4000
progress-color=source %s

[urgency=low]
border-color=%s

[urgency=normal]
border-color=%s

[urgency=critical]
border-color=%s
default-timeout=0

# OSD notifications (volume/brightness) — replace in place, no stacking
[app-name="minimal-osd"]
group-by=category
default-timeout=1500
border-color=%s
progress-color=source %s
]],
        hex_colors.surface, hex_colors.text, hex_colors.highlight, hex_colors.primary,
        hex_colors.muted, hex_colors.highlight, hex_colors.danger,
        hex_colors.primary, hex_colors.primary
    )
    write_file(base_dir .. "/mako/config", mako_config)
end

local palette_path = find_palette_path()
if palette_path then
    parse_palette(palette_path)
end

if arg and arg[0] and (arg[0]:match("colors%.lua$") or arg[0]:match("colors$")) then
    local repo_root = "."
    if palette_path then
        repo_root = palette_path:match("^(.*)[/\\]palette%.md$") or "."
    end
    generate_targets(repo_root)
end

return colors
