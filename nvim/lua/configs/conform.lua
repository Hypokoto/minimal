local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    rust = { "rustfmt" },
    -- java has no first-class conform formatter without extra tooling
    -- (google-java-format needs a JAR + wrapper script) — flagged, not solved
  },

  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
