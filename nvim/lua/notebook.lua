local M = {}

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<leader>ji", "<cmd>MoltenInit<CR>", "Jupyter: init kernel")
map("n", "<leader>je", "<cmd>MoltenEvaluateOperator<CR>", "Jupyter: evaluate operator")
map("n", "<leader>jl", "<cmd>MoltenEvaluateLine<CR>", "Jupyter: evaluate line")
map("v", "<leader>jr", ":<C-u>MoltenEvaluateVisual<CR>gv", "Jupyter: evaluate selection")
map("n", "<leader>jr", "<cmd>MoltenReevaluateCell<CR>", "Jupyter: rerun cell")
map("n", "<leader>jo", "<cmd>noautocmd MoltenEnterOutput<CR>", "Jupyter: open output")
map("n", "<leader>jx", "<cmd>MoltenOpenInBrowser<CR>", "Jupyter: open HTML output")
map("n", "<leader>jI", "<cmd>MoltenImportOutput<CR>", "Jupyter: import outputs")
map("n", "<leader>jE", "<cmd>MoltenExportOutput!<CR>", "Jupyter: export outputs")

local function clear_molten_images()
  pcall(function()
    require("load_image_nvim").image_api.clear_all()
  end)
  vim.cmd.redraw()
end

local function run_molten_command(command)
  return function()
    pcall(vim.cmd, command)
    clear_molten_images()
  end
end

map("n", "<leader>jh", run_molten_command("MoltenHideOutput"), "Jupyter: hide output")
map("n", "<leader>jd", run_molten_command("MoltenDelete"), "Jupyter: delete output")
map("n", "<leader>jD", run_molten_command("MoltenDelete!"), "Jupyter: delete all outputs")

local function is_python_buffer()
  return vim.bo.filetype == "python"
end

local function with_notebook_navigator(fn_name, ...)
  local args = { ... }
  local unpack_args = table.unpack or unpack

  return function()
    local ok, navigator = pcall(require, "notebook-navigator")
    if not ok then
      vim.notify("NotebookNavigator.nvim is not loaded", vim.log.levels.WARN)
      return
    end

    navigator[fn_name](unpack_args(args))
  end
end

local function with_quarto_runner(fn_name)
  return function()
    local ok, runner = pcall(require, "quarto.runner")
    if not ok then
      vim.notify("quarto-nvim is not loaded", vim.log.levels.WARN)
      return
    end

    runner[fn_name]()
  end
end

local function run_cell()
  if is_python_buffer() then
    with_notebook_navigator("run_cell")()
  else
    with_quarto_runner("run_cell")()
  end
end

local function run_and_move()
  if is_python_buffer() then
    with_notebook_navigator("run_and_move")()
  else
    with_quarto_runner("run_cell")()
  end
end

local function run_all_cells()
  if is_python_buffer() then
    with_notebook_navigator("run_all_cells")()
  else
    with_quarto_runner("run_all")()
  end
end

local function run_cells_below()
  if is_python_buffer() then
    with_notebook_navigator("run_cells_below")()
  else
    with_quarto_runner("run_below")()
  end
end

map("n", "]b", with_notebook_navigator("move_cell", "d"), "Jupyter: next cell")
map("n", "[b", with_notebook_navigator("move_cell", "u"), "Jupyter: previous cell")
map("n", "<leader>jc", run_cell, "Jupyter: run cell")
map("n", "<leader>jn", run_and_move, "Jupyter: run cell and move")
map("n", "<leader>jA", run_all_cells, "Jupyter: run all cells")
map("n", "<leader>jb", run_cells_below, "Jupyter: run cells below")
map("n", "<leader>j+", with_notebook_navigator("add_cell_below"), "Jupyter: add cell below")
map("n", "<leader>j-", with_notebook_navigator("add_cell_above"), "Jupyter: add cell above")
map("n", "<leader>js", with_notebook_navigator("split_cell"), "Jupyter: split cell")
map("n", "<leader>jm", with_notebook_navigator("merge_cell", "u"), "Jupyter: merge cell above")
map("n", "<leader>jL", with_quarto_runner("run_line"), "Jupyter: run current line")
map("v", "<leader>jR", with_quarto_runner("run_range"), "Jupyter: run range")

local default_notebook = [[
{
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    ""
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
]]

local function ensure_ipynb_extension(path)
  if path:match("%.ipynb$") then
    return path
  end

  return path .. ".ipynb"
end

local function new_notebook(path)
  local notebook_path = ensure_ipynb_extension(vim.fn.expand(path))
  if vim.fn.filereadable(notebook_path) == 1 then
    vim.cmd.edit(vim.fn.fnameescape(notebook_path))
    return
  end

  local parent = vim.fs.dirname(notebook_path)
  if parent and parent ~= "" then
    vim.fn.mkdir(parent, "p")
  end

  local file = assert(io.open(notebook_path, "w"))
  file:write(default_notebook)
  file:close()
  vim.cmd.edit(vim.fn.fnameescape(notebook_path))
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = "file",
})

local function read_notebook_kernel(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local contents = file:read("*a")
  file:close()

  local ok, notebook = pcall(vim.json.decode, contents)
  if not ok then
    return nil
  end

  return notebook.metadata
      and notebook.metadata.kernelspec
      and notebook.metadata.kernelspec.name
end

local function active_env_name()
  local env = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
  if not env then
    return nil
  end

  return vim.fs.basename(env)
end

local function pick_kernel(path, kernels)
  local notebook_kernel = read_notebook_kernel(path)
  if notebook_kernel and vim.tbl_contains(kernels, notebook_kernel) then
    return notebook_kernel
  end

  local env_kernel = active_env_name()
  if env_kernel and vim.tbl_contains(kernels, env_kernel) then
    return env_kernel
  end

  if vim.tbl_contains(kernels, "python3") then
    return "python3"
  end

  return nil
end

local function molten_initialized()
  local ok, status = pcall(require, "molten.status")
  return ok and status.initialized() == "Molten"
end

local function init_molten_for_path(path)
  if molten_initialized() then
    return
  end

  local ok, kernels = pcall(vim.fn.MoltenAvailableKernels)
  if not ok or type(kernels) ~= "table" then
    return
  end

  local kernel = pick_kernel(path, kernels)
  if kernel then
    pcall(vim.cmd, "MoltenInit " .. vim.fn.fnameescape(kernel))
  end
end

local function init_notebook_outputs(event)
  vim.schedule(function()
    init_molten_for_path(event.file)
    pcall(vim.cmd, "MoltenImportOutput")
  end)
end

local function has_percent_cells(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(vim.api.nvim_buf_line_count(bufnr), 1000), false)
  for _, line in ipairs(lines) do
    if line:match("^%s*#%s*%%%%") then
      return true
    end
  end

  return false
end

local function init_python_percent_file(event)
  if vim.b[event.buf].notebook_auto_init_done or not has_percent_cells(event.buf) then
    return
  end

  vim.b[event.buf].notebook_auto_init_done = true
  vim.schedule(function()
    init_molten_for_path(event.file)
  end)
end

local notebook_group = vim.api.nvim_create_augroup("Notebook", { clear = true })
vim.api.nvim_create_autocmd("BufAdd", {
  group = notebook_group,
  pattern = "*.ipynb",
  callback = init_notebook_outputs,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = notebook_group,
  pattern = "*.ipynb",
  callback = function(event)
    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
      init_notebook_outputs(event)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = notebook_group,
  pattern = "*.ipynb",
  callback = function()
    if molten_initialized() then
      pcall(vim.cmd, "MoltenExportOutput!")
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
  group = notebook_group,
  pattern = "*.py",
  callback = init_python_percent_file,
})

return M
