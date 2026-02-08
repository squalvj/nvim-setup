return {
  "loctvl842/monokai-pro.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    vim.cmd("syntax enable")
    vim.cmd("filetype plugin indent on")

    require("monokai-pro").setup({
      override = function(scheme)
        return {
          typescriptVariable = { fg = scheme.base.orange, bold = true },
          Normal = { bg = "#000000" },
          IndentBlanklineChar = { fg = scheme.base.dimmed4 },
          Keyword = { fg = scheme.base.blue },
          Constant = { fg = scheme.base.magenta },
          Function = { fg = scheme.base.green },
        }
      end,
      filter = "spectrum", -- try "machine" or "octagon" if you like
    })
    vim.cmd.colorscheme("monokai-pro")
  end,
}
