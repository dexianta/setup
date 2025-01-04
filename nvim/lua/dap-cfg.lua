-------------
-- dap go
-------------
require("dap-go").setup({})
require("nvim-dap-virtual-text").setup({
  enabled = false,
  clear_on_continue = true, -- clear virtual text on "continue" (might cause flickering when stepping)
})

local dap, dapui = require("dap"), require("dapui")

dapui.setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
})

-------------
-- dap python
-------------
local dap_python = require("dap-python")
dap_python.setup("/Users/dexian/miniconda3/bin/python")
dap_python.test_runner = "pytest"

dap.set_log_level("DEBUG")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function() end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters.executable = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
  name = "lldb1",
  host = "127.0.0.1",
  port = 13000,
}
dap.adapters.codelldb = {
  name = "codelldb server",
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}
dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},

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
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

--- key binding
keymap("n", "<Leader>cb", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
keymap("n", "<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
keymap("n", "<Leader>u", ":lua require'dapui'.toggle()<CR>")
keymap("n", "<Leader>tp", ":lua require('dap-python').test_method()<CR>")
keymap("n", "<Leader>tg", ":lua require('dap-go').debug_test()<CR>")
keymap("n", "<Leader>c", ":lua require'dap'.continue()<CR>")
keymap("n", "<Leader>l", ":lua require'dap'.run_last()<CR>")
keymap("n", "<Leader>n", ":lua require'dap'.step_over()<CR>")
keymap("n", "<Leader>i", ":lua require'dap'.step_into()<CR>")
