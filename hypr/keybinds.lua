-- ==============================================================================
-- Minimal — Global Keybindings & Window Management Architecture
-- Native Hyprland 0.55+ Lua Dispatchers (100% Validated & Standardized)
-- ==============================================================================

local mainMod = "SUPER"
local hyprScripts = os.getenv("HOME") .. "/.config/hypr/scripts"

-- ==============================================================================
-- 1. CORE APPLICATIONS & SESSION
-- ==============================================================================
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("kitty"), { description = "App: Launch terminal (Kitty)" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "Window: Close active window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill(), { description = "Window: Force kill window" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit(), { description = "Session: Exit Hyprland session" })

-- ==============================================================================
-- 2. WINDOW CONTROLS & STATE (Float, Fullscreen, Maximize, Minimize, Pin, Center)
-- ==============================================================================
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "Window: Toggle floating state" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }), { description = "Window: Toggle fullscreen mode" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = 1 }), { description = "Window: Maximize (preserve bar)" })
hl.bind(mainMod .. " + M", hl.dsp.window.move({ workspace = "special:minimized" }), { description = "Window: Minimize to tray" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.workspace.toggle_special({ name = "minimized" }), { description = "Window: Restore minimized tray" })
hl.bind(mainMod .. " + P", hl.dsp.window.pin(), { description = "Window: Pin (always-on-top)" })
hl.bind(mainMod .. " + ALT + C", hl.dsp.window.center(), { description = "Window: Center floating window" })
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd(hyprScripts .. "/window-recover.sh"), { description = "Window: Emergency recovery to active workspace" })

-- ==============================================================================
-- 3. WINDOW GROUPING & TABBING
-- ==============================================================================
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "Group: Toggle tabbed window group" })
hl.bind(mainMod .. " + ALT + period", hl.dsp.group.next(), { description = "Group: Focus next tab" })
hl.bind(mainMod .. " + ALT + comma",  hl.dsp.group.prev(), { description = "Group: Focus previous tab" })

-- ==============================================================================
-- 4. SPATIAL FOCUS NAVIGATION (Vim Grammar: SUPER + H/J/K/L)
-- ==============================================================================
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }), { description = "Focus: Move focus left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }), { description = "Focus: Move focus right" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }), { description = "Focus: Move focus up" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }), { description = "Focus: Move focus down" })

-- Multi-Monitor Focus Navigation
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ monitor = "+1" }), { description = "Focus: Focus next monitor" })
hl.bind(mainMod .. " + bracketleft",  hl.dsp.focus({ monitor = "-1" }), { description = "Focus: Focus previous monitor" })

-- ==============================================================================
-- 5. SPATIAL WINDOW SNAPPING (Windows Snap Layouts)
-- ==============================================================================
-- Half-Screen Snapping (SUPER + Arrow Keys)
hl.bind(mainMod .. " + Left",  hl.dsp.exec_cmd(hyprScripts .. "/snap.sh left"), { description = "Snap: Snap left half" })
hl.bind(mainMod .. " + Right", hl.dsp.exec_cmd(hyprScripts .. "/snap.sh right"), { description = "Snap: Snap right half" })
hl.bind(mainMod .. " + Up",    hl.dsp.exec_cmd(hyprScripts .. "/snap.sh top"), { description = "Snap: Snap top half" })
hl.bind(mainMod .. " + Down",  hl.dsp.exec_cmd(hyprScripts .. "/snap.sh bottom"), { description = "Snap: Snap bottom half" })

-- Quarter-Screen Snapping (SUPER + ALT + Arrow Keys)
hl.bind(mainMod .. " + ALT + Left",  hl.dsp.exec_cmd(hyprScripts .. "/snap.sh top-left"), { description = "Snap: Snap top-left quarter" })
hl.bind(mainMod .. " + ALT + Right", hl.dsp.exec_cmd(hyprScripts .. "/snap.sh top-right"), { description = "Snap: Snap top-right quarter" })
hl.bind(mainMod .. " + ALT + Up",    hl.dsp.exec_cmd(hyprScripts .. "/snap.sh bottom-left"), { description = "Snap: Snap bottom-left quarter" })
hl.bind(mainMod .. " + ALT + Down",  hl.dsp.exec_cmd(hyprScripts .. "/snap.sh bottom-right"), { description = "Snap: Snap bottom-right quarter" })

-- ==============================================================================
-- 6. WINDOW POSITIONING, SWAPPING & MONITOR MOVEMENT
-- ==============================================================================
-- Move window position directionally (SUPER + SHIFT + H/J/K/L)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "Move: Move window left" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "Move: Move window right" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "Move: Move window up" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "Move: Move window down" })

-- Swap active window with neighbor window (SUPER + ALT + H/J/K/L)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.swap({ direction = "l" }), { description = "Swap: Swap with left neighbor" })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.swap({ direction = "r" }), { description = "Swap: Swap with right neighbor" })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.swap({ direction = "u" }), { description = "Swap: Swap with top neighbor" })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.swap({ direction = "d" }), { description = "Swap: Swap with bottom neighbor" })

-- Move window to Next/Previous Monitor (SUPER + SHIFT + ] / [)
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ monitor = "+1" }), { description = "Move: Relocate window to next monitor" })
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ monitor = "-1" }), { description = "Move: Relocate window to prev monitor" })

-- ==============================================================================
-- 7. INTERACTIVE WINDOW RESIZING & MOUSE DRAG
-- ==============================================================================
-- Resize window dimensions (SUPER + CTRL + H/J/K/L)
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true, description = "Resize: Shrink width" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true, description = "Resize: Expand width" })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true, description = "Resize: Shrink height" })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true, description = "Resize: Expand height" })

-- Mouse Interactive Drag & Resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ==============================================================================
-- 8. WORKSPACE NAVIGATION & TASK OVERVIEW (hyprtasking)
-- ==============================================================================
-- macOS Relative Workspace Navigation (SUPER + CTRL + Left/Right)
hl.bind(mainMod .. " + CTRL + Left",  hl.dsp.focus({ workspace = "e-1" }), { description = "Workspace: Previous workspace" })
hl.bind(mainMod .. " + CTRL + Right", hl.dsp.focus({ workspace = "e+1" }), { description = "Workspace: Next workspace" })

-- macOS Relative Window Relocation (SUPER + SHIFT + Up/Down)
hl.bind(mainMod .. " + SHIFT + Up",   hl.dsp.window.move({ workspace = "e-1" }), { description = "Workspace: Move window to prev workspace" })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Workspace: Move window to next workspace" })

for i = 1, 9 do
    -- SUPER + 1..9: Focus workspace
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }), { description = "Workspace: Switch to workspace " .. i })
    -- SUPER + SHIFT + 1..9: Move active window to workspace
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), { description = "Workspace: Move window to " .. i })
    -- SUPER + CTRL + 1..9: Move active window to workspace AND follow focus
    hl.bind(mainMod .. " + CTRL + " .. i, function()
        hl.dispatch(hl.dsp.window.move({ workspace = i }))
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end, { description = "Workspace: Move window to " .. i .. " and follow" })
end

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }), { description = "Workspace: Switch to workspace 10" })
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }), { description = "Workspace: Move window to 10" })

-- Task Overview (hyprtasking) & Workspace Navigation
hl.bind(mainMod .. " + Tab",        hl.dsp.focus({ workspace = "previous" }), { description = "Workspace: Focus previous active workspace" })
hl.bind(mainMod .. " + T", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { description = "Tasking: Toggle grid overview" })
hl.bind(mainMod .. " + TAB", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("cursor")
    end
end, { description = "Tasking: Toggle cursor overview" })
hl.bind(mainMod .. " + grave", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { description = "Tasking: Toggle grid overview" })
hl.bind(mainMod .. " + SHIFT + grave", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { description = "Tasking: Toggle grid overview (tilde)" })
hl.bind(mainMod .. " + asciitilde", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { description = "Tasking: Toggle grid overview (asciitilde)" })
hl.bind(mainMod .. " + code:49", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.toggle then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { description = "Tasking: Toggle grid overview (keycode 49)" })
hl.bind(mainMod .. " + SHIFT + Q", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.killhovered then
        hl.plugin.hyprtasking.killhovered()
    end
end, { description = "Tasking: Kill hovered window in overview" })

-- Overview Arrow Keys Navigation & Enter Selection
hl.bind("Up", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.move("up")
    end
end, { non_consuming = true, description = "Tasking: Move focus up in grid" })
hl.bind("Down", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.move("down")
    end
end, { non_consuming = true, description = "Tasking: Move focus down in grid" })
hl.bind("Left", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.move("left")
    end
end, { non_consuming = true, description = "Tasking: Move focus left in grid" })
hl.bind("Right", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.move("right")
    end
end, { non_consuming = true, description = "Tasking: Move focus right in grid" })
hl.bind("Return", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.move("out")
    end
end, { non_consuming = true, description = "Tasking: Select workspace on Enter" })

hl.bind("Escape", function()
    if hl.plugin and hl.plugin.hyprtasking and hl.plugin.hyprtasking.is_active and hl.plugin.hyprtasking.is_active() then
        hl.plugin.hyprtasking.toggle("all")
    end
end, { non_consuming = true, description = "Tasking: Exit overview on Escape" })
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- ==============================================================================
-- 9. SYSTEM OVERLAYS, SCRATCHPADS & ROFI MENUS
-- ==============================================================================
hl.bind(mainMod .. " + S",      hl.dsp.workspace.toggle_special({ name = "scratchpad" }), { description = "Special: Toggle scratchpad" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("quickshell ipc call minimal-shell toggleLauncher"), { description = "Launcher: Toggle app launcher" })
hl.bind(mainMod .. " + X",      hl.dsp.exec_cmd("quickshell ipc call minimal-shell toggleClipboard"), { description = "Clipboard: Toggle clipboard history" })
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("quickshell ipc call minimal-shell toggleWallpaper"), { description = "Wallpaper: Toggle wallpaper changer" })
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(hyprScripts .. "/toggle-bar.sh"), { description = "Shell: Toggle top bar" })
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("quickshell ipc call minimal-shell toggleControl"), { description = "Launcher: Toggle quick controls menu" })
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(hyprScripts .. "/gamemode.sh"), { description = "Performance: Toggle Game Mode (disable animations/blur)" })
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd(hyprScripts .. "/ocr.sh"), { description = "Utilities: Screen OCR text extractor to clipboard" })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(hyprScripts .. "/screen-record.sh"), { description = "Utilities: Toggle Screen Recording" })
hl.bind(mainMod .. " + ALT + R",   hl.dsp.exec_cmd(hyprScripts .. "/screen-record.sh --region"), { description = "Utilities: Toggle Region Screen Recording" })
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(hyprScripts .. "/nightlight.sh"), { description = "Utilities: Toggle Night Light shader (hyprsunset)" })
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("quickshell ipc call minimal-shell toggleSession"), { description = "Session: Toggle power menu overlay" })
hl.bind(mainMod .. " + ALT + Escape", hl.dsp.exec_cmd("quickshell ipc call minimal-shell lock"), { description = "Session: Lock screen" })

-- ==============================================================================
-- 10. MEDIA & OSD PIPELINE
-- ==============================================================================
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "Media: Play/Pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, description = "Media: Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, description = "Media: Previous track" })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true, description = "Volume: Raise volume (+5%)" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true, description = "Volume: Lower volume (-5%)" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, description = "Volume: Mute toggle" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, description = "Mic: Mute mic toggle" })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true, description = "Brightness: Increase display brightness (+5%)" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true, description = "Brightness: Decrease display brightness (-5%)" })

-- ==============================================================================
-- 11. SCREENSHOTS
-- ==============================================================================
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'Screenshot' 'Copied to clipboard'"), { locked = true, description = "Screenshot: Fullscreen >> clipboard" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Screenshot' 'Area copied to clipboard'"), { locked = true, description = "Screenshot: Region >> clipboard" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    "mkdir -p " .. os.getenv("HOME") .. "/Pictures/Screenshots && " ..
    "grim -g \"$(slurp)\" " .. os.getenv("HOME") .. "/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png && " ..
    "notify-send 'Screenshot' 'Area saved'"
), { locked = true, description = "Screenshot: Region >> file" })
