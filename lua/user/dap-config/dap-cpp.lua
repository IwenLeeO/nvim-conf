-- local dap = require('dap')
-- dap.adapters.lldb = {
--   type = "executable",
--   command = "/home/wenhao_li/llvm-project/build/bin/lldb-vscode",
--   name = "lldb",
-- }
-- local get_args = function()
--   -- 获取输入命令行参数
--   local cmd_args = vim.fn.input('CommandLine Args:')
--   local params = {}
--   -- 定义分隔符(%s在lua内表示任何空白符号)
--   local sep = "%s"
--   for param in string.gmatch(cmd_args, "[^%s]+") do
--     table.insert(params, param)
--   end
--   return params
-- end;
--
-- local function get_executable_from_cmake(path)
--   -- 使用awk获取CMakeLists.txt文件内要生成的可执行文件的名字
--   local get_executable = 'awk "BEGIN {IGNORECASE=1} /add_executable\\s*\\([^)]+\\)/ {match(\\$0, /\\(([^\\)]+)\\)/,m);match(m[1], /([A-Za-z_]+)/, n);printf(\\"%s\\", n[1]);}" '
--       .. path .. "CMakeLists.txt"
--   return vim.fn.system(get_executable)
-- end
--
-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "lldb",
--     request = "launch",
--     program = function()
--       local current_path = vim.fn.getcwd() .. "/"
--
--       print(current_path)
--       -- 使用find命令找到Makefile或者makefile
--       local fd_make = string.format('find %s -maxdepth 1 -name [m\\|M]akefile', current_path)
--       local fd_make_result = vim.fn.system(fd_make)
--       if (fd_make_result ~= "")
--       then
--         local mkf = vim.fn.system(fd_make)
--         -- 使用awk默认提取Makefile(makefile)中第一个的将要生成的可执行文件名称
--         local cmd = 'awk "\\$0 ~ /:/ { match(\\$1, \\"([A-Za-z_]+)\\", m); printf(\\"%s\\", m[1]); exit; }" ' .. mkf
--         local exe = vim.fn.system(cmd)
--         -- 执行make命令
--         -- Makefile里面需要设置CXXFLAGS变量哦~
--         if (os.execute('sudo make CXXFLAGS="-g"'))
--         then
--           return current_path .. exe
--         end
--       end
--       -- 查找CMakeLists.txt文件
--       local fd_cmake = string.format("find %s -name CMakeLists.txt -type f", current_path)
--       local fd_cmake_result = vim.fn.system(fd_cmake)
--       if (fd_cmake_result == "")
--       then
--         return vim.fn.input("Path to executable: ", current_path, "file")
--       end
--       -- 查找build文件夹
--       local fd_build = string.format("find %s -name build -type d", current_path)
--       local fd_build_result = vim.fn.system(fd_build)
--       if (fd_build_result == "")
--       then
--         -- 不存在则创建build文件夹
--         if (not os.execute(string.format('mkdir -p %sbuild', current_path)))
--         then
--           return vim.fn.input("Path to executable: ", current_path, "file")
--         end
--       end
--       local cmd = 'cd ' .. current_path .. "build && cmake .. -DCMAKE_BUILD_TYPE=Debug"
--       -- 开始构建项目
--       print("Building The Project...")
--       vim.fn.system(cmd)
--       local exec = get_executable_from_cmake(current_path)
--       local make = 'cd ' .. current_path .. 'build && sudo make'
--       local res = vim.fn.system(make)
--       if (exec == "" or res == "")
--       then
--         return vim.fn.input("Path to executable: ", current_path, "file")
--       end
--
--       return current_path .. "build/" .. exec
--     end,
--     print "${workspaceFolder}",
--     cwd = "${workspaceFolder}",
--     stopOnEntry = false,
--     args = get_args,
--   },
-- }
-- dap.configurations.c = dap.configurations.cpp
-- local dap = require('dap')
-- dap.configurations.cpp = {
--   {
--     name = 'Launch',
--     type = 'lldb',
--     request = 'launch',
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  -- },
-- }

-- If you want to use this for Rust and C, add something like this:

-- dap.configurations.c = dap.configurations.cpp
-- dap.configurations.rust = dap.configurations.cpp


local dap = require("dap")
local cmd = os.getenv('HOME') .. '/.config/nvim/data/debug/tools/extension/adapter/codelldb'
dap.adapters.codelldb = function(on_adapter)
  -- This asks the system for a free port
  local tcp = vim.loop.new_tcp()
  tcp:bind('127.0.0.1', 0)
  local port = tcp:getsockname().port
  tcp:shutdown()
  tcp:close()

  -- Start codelldb with the port
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local opts = {
    stdio = {nil, stdout, stderr},
    args = {'--port', tostring(port)},
  }
  local handle
  local pid_or_err
  handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print("codelldb exited with code", code)
    end
  end)
  if not handle then
    vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
    stdout:close()
    stderr:close()
    return
  end
  vim.notify('codelldb started. pid=' .. pid_or_err)
  stderr:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  local adapter = {
    type = 'server',
    host = '127.0.0.1',
    port = port
  }
  -- 💀
  -- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
  -- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
  vim.defer_fn(function() on_adapter(adapter) end, 500)
end

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
            local handle = io.popen('pgrep hw$')
            local result = handle:read()
            handle:close()
            return result
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    terminal = 'integrated',
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
