-- ==============================================================================
-- Minimal — Monitor Topology (Lua, Device-Compatible)
-- Auto-configures any and all connected outputs at their preferred mode.
-- Position "auto" lets Hyprland tile displays left-to-right automatically,
-- so this single config works on laptops (internal only), desktops
-- (single or multiple externals), and hotplugged USB-C/HDMI adapters.
--
-- To inspect live connector names:  hyprctl monitors all
-- Common names: eDP-1, eDP-2, HDMI-A-1, DP-1, DP-2, HDMI-A-2
--
-- Override a specific output (e.g. cap external at 1080p@60) by adding
-- an explicit hl.monitor{} call BEFORE the catch-all.  Example:
--   hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = "1" })
-- ==============================================================================

-- Explicit external monitor rules (HDMI-A-1, HDMI-A-2, DP-1, DP-2)
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output   = "DP-1",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-- Catch-all: every connected output gets preferred mode, auto position, scale 1.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

-- ================================================================
-- Workspace rules
-- ================================================================
-- No static monitor→workspace pinning.  Workspaces are dynamically
-- assigned by Hyprland to whichever monitor is active, so the same
-- config works regardless of how many (or which) displays are connected.
-- Workspace 1 is the default landing workspace.
-- ================================================================
for i = 1, 9 do
    hl.workspace_rule({
        workspace = tostring(i),
        default   = (i == 1),
    })
end
