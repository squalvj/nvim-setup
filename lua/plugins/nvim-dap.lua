return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',  -- required by nvim-dap-ui
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    
    -- Setup dap-ui
    dapui.setup()
    
    -- Automatically open/close UI when debugging starts/ends
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
  end,
}
