vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
require("config.lazy")

-- Personal keymap

-- === Positioning utilities ===
-- Center screen when moving with Ctrl+d/u
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Move lines up and down
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { silent = true })

-- Telescope
require("telescope").load_extension("flutter")
local builtin = require("telescope.builtin")

-- Existing keymaps
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', { desc = 'Find diagnostics' })

-- Flutter telescope keymaps
vim.keymap.set('n', '<leader>flut', '<cmd>Telescope flutter commands<cr>', { desc = 'Flutter commands' })

-- Neotree
require("neo-tree").setup({
  filesystem = {
    use_libuv_file_watcher = true,  -- Auto-watch filesystem changes
  }
})

vim.keymap.set("n", "<leader>b", ":Neotree toggle<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Bufferline
vim.opt.termguicolors = true
require("bufferline").setup{
  options = {
    custom_filter = function(buf_number, buf_numbers)
      -- Filter out [No Name] buffers
      local bufname = vim.fn.bufname(buf_number)
      if bufname == "" then
        return false
      end
      return true
    end,
  }
}
    
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
require("flutter-tools").setup {
  lsp = {
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
  },
  debugger = {
    enabled = true
  },
  -- dev_log = {
    -- enabled = false
  -- }
} 

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

  -- Open LazyGit
  vim.cmd('LazyGit')
  
  -- Re-enable blame after closing (optional)
  vim.api.nvim_create_autocmd('TermClose', {
    once = true,
    callback = function()
      vim.defer_fn(function()
        -- Refresh neo-tree git status properly
        local ok, events = pcall(require, "neo-tree.events")
        if ok then
          events.fire_event(events.GIT_EVENT)
        end
        pcall(vim.cmd, 'Gitsigns refresh')
        pcall(vim.cmd, 'Gitsigns toggle_current_line_blame')
      end, 150)  -- Slightly longer delay for git operations
    end,
  })
end, { desc = 'LazyGit' })

-- GitSigns related
vim.keymap.set('n', '<leader>gb', '<cmd>Gitsigns preview_hunk<cr>', {})


-- Nvim ufo (folding stuff)
-- Folding core
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""
vim.opt.fillchars = {
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ", -- critical
}
vim.o.foldlevel = 99        -- keep folds open by default
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Optional: cleaner look
vim.opt.number = false
vim.opt.relativenumber = false

vim.keymap.set("n", "zR", function()
  require("ufo").openAllFolds()
end)

vim.keymap.set("n", "zM", function()
  require("ufo").closeAllFolds()
end)

require("ufo").setup({
  provider_selector = function(_, filetype)
    if filetype == "dart" then
      return { "indent" }      -- safe fallback for Dart
    end
    return { "lsp", "indent" } -- use LSP where available, indent otherwise
  end,

  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local foldedLines = endLnum - lnum
    local suffix = ("   %d lines"):format(foldedLines)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)
      if curWidth + chunkWidth <= targetWidth then
        table.insert(newVirtText, chunk)
        curWidth = curWidth + chunkWidth
      else
        local truncated = truncate(chunkText, targetWidth - curWidth)
        table.insert(newVirtText, { truncated, chunk[2] })
        curWidth = curWidth + vim.fn.strdisplaywidth(truncated)
        break
      end
    end

    table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
    return newVirtText
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.require'ufo'.foldexpr()"

    -- ensure folds are calculated immediately
    vim.defer_fn(function()
      require("ufo").openAllFolds()
    end, 20)
  end,
})

vim.api.nvim_set_hl(0, "UfoFoldedBg", {
  bg = "#3E3D32", -- Monokai selection bg
})

vim.api.nvim_set_hl(0, "UfoFoldedFg", {
  fg = "#E6DB74", -- Monokai yellow
})

vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", {
  fg = "#FD971F", -- Monokai orange
})
