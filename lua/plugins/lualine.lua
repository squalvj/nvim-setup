return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function()
    local lsp_status = function()
      local clients = vim.lsp.get_active_clients({bufnr = 0})
      if next(clients) == nil then
        return ''
      end
      local names = {}
      for _, client in pairs(clients) do
        table.insert(names, client.name)
      end
      return ' ' .. table.concat(names, ', ')
    end

    return {
      options = {
        theme = 'auto',         -- automatically adapts to your colorscheme
        globalstatus = true,    -- one statusline for all windows
        disabled_filetypes = {  -- optional: don't show for some buffers
          'NvimTree',
          'packer',
          'neo-tree',
        },
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff'},
        lualine_c = {'filename', lsp_status},
        lualine_x = {'diagnostics', 'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {'fugitive', 'quickfix'}
    }
  end
}
