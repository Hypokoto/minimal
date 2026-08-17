-- ==============================================================================
-- Minimal — Global Keybindings & Media Pipeline (Lua port)
-- ==============================================================================
-- Confirmed against the current hl.dsp API surface (wiki.hypr.land/Configuring/Basics/Binds
-- and .../Dispatchers as of the 0.55 Lua release). A few dispatcher names below are NOT
-- fully confirmed by docs at time of writing — marked with -- VERIFY. Check them with your
-- editor's LSP (stubs live in /usr/share/hypr/stubs/) or `hyprctl` before relying on them.

local mainMod = "SUPER"

-- --- Core Applications ---
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/rofi/scripts/launcher.sh"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- VERIFY: fullscreen / pseudotile dispatcher shape wasn't confirmed in current docs search.
-- Your original bound BOTH mainMod+P and mainMod+T to `pseudo` (duplicate — probably a typo
-- in the original; T was likely meant for something else). Kept as-is, flagged.
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" })) -- VERIFY
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())                          -- VERIFY
hl.bind(mainMod .. " + T", hl.dsp.window.pseudo())                          -- VERIFY (duplicate of +P in your original)

-- --- Focus Movement (Vim-style) ---
-- VERIFY: directional focus dispatcher. Confirmed pattern for focusing a specific window is
-- hl.dsp.focus({ window = "..." }); direction-based movefocus equivalent is inferred as
-- hl.dsp.focus({ direction = "l" }) but wasn't directly confirmed in docs at time of writing.
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" })) -- VERIFY
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" })) -- VERIFY
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" })) -- VERIFY
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" })) -- VERIFY

-- --- Workspaces (1-9) ---
-- Workspaces are dynamically assigned by Hyprland to whichever monitor is
-- active (see monitors.lua).  This works on single-display laptops, multi-
-- monitor desks, or any hotplugged adapter configuration.
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- --- Workspace Navigation & Toggling ---
hl.bind(mainMod .. " + Tab",        hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))-- --- Media & OSD Pipeline ---
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

local hyprScripts = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && " .. hyprScripts .. "/osd-volume.sh"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && " .. hyprScripts .. "/osd-volume.sh"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && " .. hyprScripts .. "/osd-volume.sh"),
    { locked = true })
hl.bind("XF86AudioMicMute",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
    { locked = true })
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl set +5% && " .. hyprScripts .. "/osd-brightness.sh"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl set 5%- && " .. hyprScripts .. "/osd-brightness.sh"),
    { locked = true, repeating = true })

-- --- Custom Rofi Script Bindings ---
local rofiScripts = os.getenv("HOME") .. "/.config/rofi/scripts"
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock")) -- Lock screen (SHIFT disambiguates from movefocus L)
                                                          -- movefocus,r above — that's a real conflict
                                                          -- in the source .conf, not introduced here.
                                                          -- Hyprland would have taken the later bind
                                                          -- (this one). Consider remapping one.
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd(rofiScripts .. "/powermenu.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(hyprScripts .. "/waybar-toggle.sh"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(rofiScripts .. "/battery.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(rofiScripts .. "/calendar.sh"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(rofiScripts .. "/emoji.sh")) -- NOTE: also conflicts with any
                                                                         -- fileManager-style +E bind if
                                                                         -- you add one later (see example
                                                                         -- config's mainMod+E = fileManager)
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(rofiScripts .. "/network.sh"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(rofiScripts .. "/clipboard.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/hypr/wallpaper/picker.sh"))

-- --- Window Drag/Resize with Mouse (confirmed shape) ---
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- --- Screenshots ---
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'Screenshot' 'Copied to clipboard'"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    "mkdir -p " .. os.getenv("HOME") .. "/Pictures/Screenshots && " ..
    "grim -g \"$(slurp)\" " .. os.getenv("HOME") .. "/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && " ..
    "notify-send 'Screenshot' 'Area saved'"
))
