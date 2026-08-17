---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "minimal",
  hl_add = {
    MinimalDashboardHeader = { fg = "#00D9FF", bold = true },
    MinimalDashboardFooter = { fg = "#8D95B3" },
  },
}

M.ui = {
  theme = "minimal",
  theme_toggle = { "minimal", "nice" },
  nvdash = {
    load_on_startup = true,
  },

  tabufline = {
    enabled = true,
    -- Shift 'treeOffset' (the sidebar space calculator) to the very end 
    -- of the array so it anchors to Neo-tree on the right.
    order = { "buffers", "tabs", "btns", "treeOffset" },
  },
}

return M
