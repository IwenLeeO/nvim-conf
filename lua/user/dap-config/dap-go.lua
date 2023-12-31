local dap = require ('dap')

-- dap.adapters.go = function(callback, config)
--   local stdout = vim.loop.new_pipe(false)
--   local handle
--   local pid_or_err
--   -- local port = 38697
--   local port = 12345
--   local opts = {
--     stdio = {nil, stdout},
--     args = {"dap", "--check-go-version=false", "--listen=127.0.0.1:" .. port, "--log-dest=3"},
--     detached = true
--   }
--   handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
--     stdout:close()
--     handle:close()
--     if code ~= 0 then
--       print('dlv exited with code', code)
--     end
--   end)
--   assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
--   stdout:read_start(function(err, chunk)
--     assert(not err, err)
--     if chunk then
--       vim.schedule(function()
--         require('dap.repl').append(chunk)
--       end)
--     end
--   end)
--   -- Wait for delve to start
--   vim.defer_fn(
--     function()
--       callback({type = "server", host = "127.0.0.1", port = port})
--     end,
--     100)
--
--   -- vim.notify("waiting load server")
-- end
--
--
-- local get_args = function()
--   -- 获取输入命令行参数
--   local cmd_args = vim.fn.input('CommandLine Args:')
--   local params = {}
--   -- 定义分隔符(%s在lua内表示任何空白符号)
--   for param in string.gmatch(cmd_args, "[^%s]+") do
--     table.insert(params, param)
--   end
--   return params
-- end;
--
-- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
-- dap.configurations.go = {
--   {
--     type = "go",
--     name = "Debug",
--     request = "launch",
--     args = get_args,
--     program = "${file}"
--   },
--   {
--     type = "go",
--     name = "Debug test", -- configuration for debugging test files
--     request = "launch",
--     mode = "test",
--     program = "${file}"
--   },
--   -- works with go.mod packages and sub packages 
--   {
--     type = "go",
--     name = "Debug test (go.mod)",
--     request = "launch",
--     mode = "test",
--     program = "./${relativeFileDirname}"
--   }
-- }



dap.adapters.go = function(callback, _)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }

  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print("dlv exited with code", code)
    end
  end)
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  end, 100)
end
local get_args = function()
  local cmd_args = vim.fn.input('CommandLine Args:')
  local params = {}
  for param in string.gmatch(cmd_args, "[^%s]+") do
    table.insert(params, param)
  end
  return params
end;
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    args = get_args,
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    args = get_args,
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Attach remote",
    mode = "remote",
    request = "attach",
  },
  {
    type = "go",
    name = "Debug Parent package",
    request = "launch",
    args = get_args,
    program = "./${relativeFileDirname}"
  }
}
