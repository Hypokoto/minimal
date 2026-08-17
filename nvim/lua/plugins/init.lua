-- lua/plugins/init.lua
local ascii_header = {
  "                                    ",
  "                                    ",
  "                                    ",
  "    ⣴⣶⣤⡤⠦⣤⣀⣤⠆      ⣈⣭⣿⣶⣿⣦⣼⣆          ",
  "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦        ",
  "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
  "            ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
  "            ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
  "    ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘   ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
  "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏   ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
  " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
  " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
  "       ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
  "        ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
  "                                    ",
}

return {
  -- ==========================================================
  -- Dashboard — snacks.nvim (NvChad's current dashboard backend,
  -- NOT alpha/dashboard-nvim; see conflict note in the reply above).
  -- ==========================================================
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = table.concat(ascii_header, "\n"),
        },
        sections = {
          { section = "header", hl = "MinimalDashboardHeader" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup", hl = "MinimalDashboardFooter" },
        },
      },
    },
  },

  -- ==========================================================
  -- Mason — ensure the three toolchains are provisioned.
  -- opts_extend keeps this list additive across other specs that
  -- also touch ensure_installed, matching the merge-behavior fix
  -- already established in this stack.
  -- ==========================================================
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "jdtls",
        "rust-analyzer",
        "codelldb", -- rust/C debug adapter, install now since the gap is already documented
      },
    },
    opts_extend = { "ensure_installed" },
  },

  -- ==========================================================
  -- nvim-lspconfig — clangd, jdtls, rust_analyzer.
  -- Actual server setup lives in lua/configs/lspconfig.lua,
  -- loaded from here to keep this file spec-only.
  -- ==========================================================
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },

  -- ==========================================================
  -- Treesitter — parser anchors for C/C++/Rust/Java.
  -- ==========================================================
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "rust",
        "java",
        "lua",
        "vim",
        "vimdoc",
      },
    },
    opts_extend = { "ensure_installed" },
  },

  -- ==========================================================
  -- File tree — forced to the right, <leader>e preserved.
  -- ==========================================================
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        side = "right",
      },
    },
  },

  {
    "nvchad/ui",
    opts = {
      tabufline = {
        lazyload = false,
        -- Force the offset rendering to align with the right sidebar
        modules = {
          -- This overrides NvChad's default left-leaning layout
          offset = { position = "right" } 
        }
      }
    }
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
}
