-- lua/custom/mappings.lua

require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  if not api.tree.is_visible() then
    api.tree.toggle { find_file = true, focus = true }
  elseif vim.bo.filetype == "NvimTree" then
    api.tree.close()
  else
    api.tree.focus()
  end
end, { desc = "Toggle/focus file tree (right)" })
