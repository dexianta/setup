keymap("n", "<Leader>cb", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
keymap("n", "<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
keymap("n", "<Leader>u", ":lua require'dapui'.toggle()<CR>")
keymap("n", "<Leader>t", ":lua require'dap-go'.debug_test()<CR>")
keymap("n", "<Leader>c", ":lua require'dap'.continue()<CR>")
keymap("n", "<Leader>l", ":lua require'dap'.run_last()<CR>")
keymap("n", "<Leader>n", ":lua require'dap'.step_over()<CR>")
keymap("n", "<Leader>i", ":lua require'dap'.step_into()<CR>")
-------------
-- dap go
-------------
require("dap-go").setup()
require("dapui").setup({
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        -- "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        -- "console"
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
})
require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  --dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
