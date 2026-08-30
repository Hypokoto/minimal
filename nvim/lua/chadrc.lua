---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "minimal",
  hl_add = {
    MinimalDashboardHeader = { fg = "#00D9FF", bold = true },
    MinimalDashboardFooter = { fg = "#8D95B3" },
    FloatBorder            = { fg = "#1C2230", bg = "#11141D" },
    NormalFloat            = { bg = "#11141D" },
    NvimTreeNormal         = { bg = "#11141D" },
    NvimTreeNormalNC       = { bg = "#11141D" },
    NvimTreeWinSeparator   = { fg = "#1C2230", bg = "#0A0C12" },
    NvimTreeFolderName     = { fg = "#5B8CFF", bold = true },
    NvimTreeOpenedFolderName = { fg = "#00D9FF", bold = true },
    LineNr                 = { fg = "#8D95B3" },
    CursorLineNr           = { fg = "#00D9FF", bold = true },
    CursorLine             = { bg = "#11141D" },
    DiagnosticError        = { fg = "#FF5470" },
    DiagnosticWarn         = { fg = "#FFCC66" },
    DiagnosticInfo         = { fg = "#61E6FF" },
    DiagnosticHint         = { fg = "#5B8CFF" },
    Visual                 = { bg = "#1C2230" },
    Pmenu                  = { bg = "#11141D", fg = "#F2F6FF" },
    PmenuSel               = { bg = "#1C2230", fg = "#00D9FF", bold = true },
    PmenuBorder            = { fg = "#1C2230", bg = "#11141D" },
  },
}

M.ui = {
  theme = "minimal",
  theme_toggle = { "minimal", "nice" },
  nvdash = {
    load_on_startup = true,
  },
  statusline = {
    theme = "minimal",
    style = "minimal",
  },
  tabufline = {
    enabled = true,
    order = { "buffers", "tabs", "btns", "treeOffset" },
  },
}

return M

