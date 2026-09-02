-- ==============================================================================
-- Minimal — Color System Compiler & Lua Export
-- Compatible with Lua 5.1 (LuaJIT) and Lua 5.4.
-- Reads palette.md as single source of truth and updates target configuration files.
-- ==============================================================================

local colors = {
    background = "rgba(0B0E14FF)",
    surface    = "rgba(11161FFF)",
    overlay    = "rgba(19212DFF)",
    text       = "rgba(E8EDF5FF)",
    muted      = "rgba(7F899BFF)",
    primary    = "rgba(7DD3FCFF)",
    secondary  = "rgba(8BA4FFFF)",
    highlight  = "rgba(B4A7FFFF)",
    success    = "rgba(8BE28BFF)",
    warning    = "rgba(E8C77BFF)",
    danger     = "rgba(F08080FF)",
    info       = "rgba(7DD3FCFF)",
}

local hex_colors = {
    background = "#0B0E14",
    surface    = "#11161F",
    overlay    = "#19212D",
    text       = "#E8EDF5",
    muted      = "#7F899B",
    primary    = "#7DD3FC",
    secondary  = "#8BA4FF",
    highlight  = "#B4A7FF",
    success    = "#8BE28B",
    warning    = "#E8C77B",
    danger     = "#F08080",
    info       = "#7DD3FC",
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
        io.flush()
    else
        print("[Minimal] WARN: Could not write target: " .. filepath)
        io.flush()
    end
end

local function generate_targets(base_dir)
    base_dir = base_dir or "."

    -- 1. rofi/theme.rasi
    local theme_rasi = string.format([[/**
 * theme.rasi — Bento Minimal Centralized Token Palette
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

    /* transparent & overlay layering */
    bg-trans:      %sEE;
    surface-trans: %sF2;
    overlay-trans: %sAA;

    font: "AdwaitaMono Nerd Font 10.5";

    background-color: transparent;
    text-color:        @fg;
    margin:  0px;
    padding: 0px;
    spacing: 0px;
}

window {
    background-color: @surface-trans;
    border:           1px;
    border-color:     @overlay;
    border-radius:    12px;
}

mainbox {
    background-color: transparent;
    padding:          20px;
    spacing:          14px;
}

inputbar {
    background-color: @overlay;
    border-radius:    8px;
    padding:          10px 14px;
    spacing:          10px;
    border:           1px;
    border-color:     %s33;
}

listview {
    spacing:          6px;
    background-color: transparent;
    border:           0px;
}

element {
    padding:          16px 20px;
    border-radius:    12px;
    background-color: @surface;
    border:           1px;
    border-color:     @overlay;
}

element selected {
    background-color: @overlay;
    border-color:     @primary;
    text-color:       @fg;
}

element normal {
    background-color: transparent;
    text-color:       @fg;
}
]],
        hex_colors.background, hex_colors.surface, hex_colors.overlay,
        hex_colors.text, hex_colors.muted, hex_colors.primary,
        hex_colors.secondary, hex_colors.highlight, hex_colors.success,
        hex_colors.warning, hex_colors.danger, hex_colors.info,
        hex_colors.background, hex_colors.surface, hex_colors.overlay,
        hex_colors.primary)
    write_file(base_dir .. "/rofi/theme.rasi", theme_rasi)

    -- 2. btop/btop.theme
    local btop_theme = string.format([[# btop tty theme — Minimal Bento
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
        hex_colors.primary, hex_colors.secondary, hex_colors.highlight,
        hex_colors.success, hex_colors.warning, hex_colors.danger,
        hex_colors.primary, hex_colors.secondary, hex_colors.info,
        hex_colors.secondary, hex_colors.highlight, hex_colors.info,
        hex_colors.primary, hex_colors.secondary, hex_colors.info,
        hex_colors.highlight, hex_colors.warning, hex_colors.danger,
        hex_colors.primary, hex_colors.secondary, hex_colors.info,
        hex_colors.highlight, hex_colors.secondary, hex_colors.info
    )
    write_file(base_dir .. "/btop/btop.theme", btop_theme)

    -- 3. kitty/kitty.conf
    local kitty_conf = string.format([[# Minimal Kitty Config — Bento Aesthetics
# Generated from palette.md — DO NOT edit directly.
font_family      AdwaitaMono Nerd Font
bold_font        auto
italic_font      auto
font_size        11.0

background_opacity 0.92
dynamic_background_opacity yes
window_padding_width 12
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
tab_bar_style         fade
tab_fade              0.5 1
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
        hex_colors.primary, hex_colors.overlay, hex_colors.background,
        hex_colors.overlay, hex_colors.primary, hex_colors.surface, hex_colors.muted
    )
    write_file(base_dir .. "/kitty/kitty.conf", kitty_conf)

    -- 4. mako/config
    local mako_config = string.format([[# Minimal Mako Config — Bento Pill Notifications & OSD
# Generated from palette.md — DO NOT edit directly.
# Requires mako >= 1.7 for progress-bar 'value' hint rendering

font=Adwaita Sans 10
background-color=%s
text-color=%s
border-color=%s
border-size=1
border-radius=12
padding=16,18
margin=10
width=340
height=110
default-timeout=4000
progress-color=source %s

[urgency=low]
border-color=%s

[urgency=normal]
border-color=%s

[urgency=critical]
border-color=%s
default-timeout=0

# OSD notifications (volume: 91110 / brightness: 91111) — replace in place, zero latency
[app-name="minimal-osd"]
group-by=category
default-timeout=1500
border-color=%s
progress-color=source %s
]],
        hex_colors.surface, hex_colors.text, hex_colors.overlay, hex_colors.primary,
        hex_colors.overlay, hex_colors.overlay, hex_colors.danger,
        hex_colors.overlay, hex_colors.primary
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
