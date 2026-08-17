-- ==============================================================================
-- Aetheria — Monitor Topology (Lua)
-- Internal: eDP-1 at preferred mode, anchored at origin
-- External: HDMI-A-1 at 1920x1080@60, positioned right of internal display
--
-- To identify connector names at runtime:
--   hyprctl monitors all
-- Common names: eDP-1, HDMI-A-1, DP-1, DP-2, HDMI-A-2
-- ==============================================================================

-- Internal laptop panel
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = "1",
})

-- External monitor — HDMI-A-1 at 1920x1080@60, right of internal display.
-- Adjust position x-offset to match internal display width:
--   1920x0  → internal is 1920px wide (FHD)
--   2560x0  → internal is 2560px wide (QHD)
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@60",
    position = "1920x0",
    scale    = "1",
})

-- Fallback: auto-configure any unrecognized output
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-- ==============================================================================
-- Workspace-to-Monitor Binding (static partition)
-- Internal (eDP-1):    1-5
-- External (HDMI-A-1): 6-9
-- `persistent = true` keeps the workspace pinned to that output even when
-- empty, instead of Hyprland reclaiming it for whichever monitor grabs it first.
-- ==============================================================================
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = (i == 1), persistent = true })
end

for i = 6, 9 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = (i == 6), persistent = true })
end
