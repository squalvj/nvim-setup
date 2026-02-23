return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = function(bufnr)
      -- only run on filetypes we care about
      return { timeout_ms = 2000, lsp_fallback = false }
    end,
    formatters_by_ft = {
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      astro = { "prettier" },
      json = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      markdown = { "prettier" },
    },
  },
}
