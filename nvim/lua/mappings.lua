-- lua/custom/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  if not api.tree.is_visible() then
    local buf = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(buf)
    local ft = vim.bo[buf].filetype
    local bt = vim.bo[buf].buftype
    if name ~= "" and ft ~= "snacks_dashboard" and bt == "" then
      api.tree.toggle { find_file = true, focus = true }
    else
      api.tree.toggle { focus = true }
    end
  elseif vim.bo.filetype == "NvimTree" then
    api.tree.close()
  else
    api.tree.focus()
  end
end, { desc = "Toggle/focus file tree (right)" })

map("n", "<leader>x", function()
  if vim.bo.filetype == "snacks_dashboard" then
    return
  end
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })
