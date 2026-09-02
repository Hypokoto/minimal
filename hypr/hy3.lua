-- ==============================================================================
-- Minimal — hy3 Plugin Dispatcher Wrapper
-- Provides safe, ergonomic Lua API bindings for the hy3 container layout engine.
-- Sourced dynamically when hy3 is enabled.
-- ==============================================================================

local M = {}

local function get_hy3()
    if hl and hl.plugin and hl.plugin.hy3 then
        return hl.plugin.hy3
    end
    return nil
end

function M.make_group(dir, opts)
    local hy3 = get_hy3()
    if hy3 and hy3.make_group then
        hy3.make_group(dir or "h", opts or {})
    end
end

function M.change_group(dir)
    local hy3 = get_hy3()
    if hy3 and hy3.change_group then
        hy3.change_group(dir or "h")
    end
end

function M.set_ephemeral(state)
    local hy3 = get_hy3()
    if hy3 and hy3.set_ephemeral then
        hy3.set_ephemeral(state)
    end
end

function M.move_focus(dir, opts)
    local hy3 = get_hy3()
    if hy3 and hy3.move_focus then
        hy3.move_focus(dir or "left", opts or {})
    end
end

function M.toggle_focus_layer(opts)
    local hy3 = get_hy3()
    if hy3 and hy3.toggle_focus_layer then
        hy3.toggle_focus_layer(opts or { warp = true })
    end
end

function M.warp_cursor()
    local hy3 = get_hy3()
    if hy3 and hy3.warp_cursor then
        hy3.warp_cursor()
    end
end

function M.move_window(dir, opts)
    local hy3 = get_hy3()
    if hy3 and hy3.move_window then
        hy3.move_window(dir or "left", opts or {})
    end
end

function M.move_to_workspace(ws, opts)
    local hy3 = get_hy3()
    if hy3 and hy3.move_to_workspace then
        hy3.move_to_workspace(ws, opts or {})
    end
end

function M.change_focus(mode)
    local hy3 = get_hy3()
    if hy3 and hy3.change_focus then
        hy3.change_focus(mode or "top")
    end
end

function M.focus_tab(opts)
    local hy3 = get_hy3()
    if hy3 and hy3.focus_tab then
        hy3.focus_tab(opts or { direction = "right" })
    end
end

function M.set_swallow(state)
    local hy3 = get_hy3()
    if hy3 and hy3.set_swallow then
        hy3.set_swallow(state)
    end
end

function M.kill_active()
    local hy3 = get_hy3()
    if hy3 and hy3.kill_active then
        hy3.kill_active()
    end
end

function M.expand(mode, opts)
    local hy3 = get_hy3()
    if hy3 and hy3.expand then
        hy3.expand(mode or "expand", opts or {})
    end
end

function M.lock_tab(state)
    local hy3 = get_hy3()
    if hy3 and hy3.lock_tab then
        hy3.lock_tab(state or "toggle")
    end
end

function M.equalize(opts)
    local hy3 = get_hy3()
    if hy3 and hy3.equalize then
        hy3.equalize(opts or {})
    end
end

function M.debug_nodes()
    local hy3 = get_hy3()
    if hy3 and hy3.debug_nodes then
        hy3.debug_nodes()
    end
end

return M
