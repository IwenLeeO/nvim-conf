local dap = require('dap')

dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
  -- launch exe
  {
    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = "launch",
    name = "Launch file",
    program = "${file}", -- This configuration will launch the current file if used.
    -- program = "/home/iwen/infinity-stones/manage.py",
    pythonPath = function()
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path then
        return venv_path .. "/bin/python"
      end
      -- return "/usr/bin/python/"
      return "/home/iwen/.pyenv/versions/3.6.5/envs/infinity-stone/bin/python"
    end
  }
}
table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'Django',
  program = vim.fn.getcwd() .. '/manage.py',  -- NOTE: Adapt path to manage.py as needed
  args = {'runserver', '--noreload'},
})
