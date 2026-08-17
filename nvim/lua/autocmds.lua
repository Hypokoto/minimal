require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      local listed = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
      end, vim.api.nvim_list_bufs())
      if #listed == 0 then
        require("snacks.dashboard").open()
      end
    end)
  end,
})
