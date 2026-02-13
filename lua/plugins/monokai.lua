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
          ["@keyword.type"] = { fg = scheme.base.red }
        }
      end,
      filter = "classic", -- try "machine" or "octagon" if you like
    })
    vim.cmd.colorscheme("monokai-pro")
  end,
}
