local M = {}

local function config_dapi_and_sign()
  local dap_install = require "dap-install"
  dap_install.setup {
    installation_path = vim.fn.stdpath "data" .. "/dapinstall/",
  }

  local dap_breakpoint = {
    error = {
      text = "",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "󰓛",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
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

  -- load from json file
  -- config per launage
  -- require("user.dap.di-go")

  require("user.dap-config.dap-python")
  -- require("config.dap.python").setup()
  -- require("config.dap.go").setup()
  require("user.dap-config.dap-go")
end

function M.setup()
  config_dapi_and_sign()
  config_dapui()
  config_debuggers() -- Debugger
end

return M
