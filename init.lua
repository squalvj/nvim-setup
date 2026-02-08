vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
require("config.lazy")

-- Color scheme
-- require("catppuccin").setup()
-- vim.cmd.colorscheme "catppuccin"

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = 'Find diagnostics' })

-- Neotree
require("neo-tree").setup({
  git_status = {
    window = {
      mappings = {
        ["s"] = "git_add_file",
        ["u"] = "git_unstage_file",
        ["A"] = "git_add_all",
        ["c"] = "git_commit",
        ["S"] = "open_split",
      },
    },
  },
})

vim.keymap.set("n", "<leader>b", ":Neotree toggle<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}
    
-- Tab to cycle buffers (like browser tabs)
vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>')
    
-- Pick buffer with letters (super fast!)
vim.keymap.set('n', '<leader>bb', '<cmd>BufferLinePick<cr>')
    
-- Close current buffer
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>')

-- LSP configs
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, bufnr = args.buf })
      end,
    })
  end,
})

-- LSP Rust related
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'rust',
  callback = function()
    vim.lsp.enable('rust-analyzer')
  end,
})

-- Flutter related
require("flutter-tools").setup {} 

-- Trouble related
require('trouble').setup({
  auto_close = false,      -- Don't close when you jump to error
  auto_jump = false,       -- Don't auto-jump when selecting
  focus = true,            -- Auto-focus Trouble when opened
})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', { desc = 'Diagnostics (Trouble)' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix (Trouble)' })

-- Lazygit related
vim.keymap.set('n', '<leader>gg', function()
  -- Disable git blame temporarily
  -- There is an issue where it couldn't be opened due to GitSigns enabled
  vim.cmd('Gitsigns toggle_current_line_blame')
  
  -- Save if modified
  if vim.bo.modified then
    vim.cmd('write')
  end
  
  -- Open LazyGit
  vim.cmd('LazyGit')
  
  -- Re-enable blame after closing (optional)
  vim.api.nvim_create_autocmd('TermClose', {
    once = true,
    callback = function()
      vim.cmd('Gitsigns toggle_current_line_blame')
    end,
  })
end, { desc = 'LazyGit' })

-- GitSigns related
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns preview_hunk<cr>', {})
