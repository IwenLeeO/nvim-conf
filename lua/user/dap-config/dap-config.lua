local M = {}

local function config_dapi_and_sign()
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
  vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })
  vim.fn.sign_define('DapBreakpoint', { text='󰧟', texthl='DapBreakpoint', linehl ='', numhl ='DapBreakpoint' })

  vim.fn.sign_define('DapBreakpointCondition', { text='', texthl='DapBreakpoint' })
  vim.fn.sign_define('DapBreakpointRejected', { text='󰰟', texthl='DapBreakpoint' })
  vim.fn.sign_define('DapLogPoint', { text='󰯾', texthl='DapLogPoint' })
  vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl = '', numhl = 'DapStopped' })
end

local function config_dapui()
  local dap, dapui = require 'dap', require 'dapui'
  dap.listeners.after.event_initialized["dapui_config"] = function()
    -- dap.repl.close()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

local function config_debuggers()
  -- local dap = require "dap"
  -- TODO: wait dap-ui for fixing temrinal layout
  -- the "30" of "30vsplit: doesn't work
  -- dap.defaults.fallback.terminal_win_cmd = '30vsplit new' -- this will be overrided by dapui
  -- dap.set_log_level("DEBUG")
  config_dapi_and_sign()
  -- load from json file
  -- config per launage
  -- require("user.dap.di-go")
  require("user.dap-config.dap-python")
  -- require("config.dap.python").setup()
  -- require("config.dap.go").setup()
  require("user.dap-config.dap-go")
end

function M.setup()
  config_dapui()
  config_debuggers() -- Debugger
end

return M
