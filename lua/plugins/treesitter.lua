return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  auto_install = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
