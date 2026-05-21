local treesitter_languages = {
  "lua",
  "json",
  "yaml",
  "sql",
  "vimdoc",
  "javascript",
  "typescript",
  "tsx",
  "css",
  "html",
  "go",
  "c",
  "bash",
  "python",
  "markdown",
  "markdown_inline",
}

local treesitter_filetypes = {
  "lua",
  "json",
  "yaml",
  "sql",
  "vimdoc",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "css",
  "html",
  "go",
  "gomod",
  "c",
  "bash",
  "sh",
  "python",
  "markdown",
}

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})
require("nvim-treesitter").install(treesitter_languages)

vim.api.nvim_create_autocmd("FileType", {
  pattern = treesitter_filetypes,
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
  },
  move = {
    set_jumps = true,
  },
})

local textobject_select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "ib", function()
  textobject_select.select_textobject("@code_cell.inner", "textobjects")
end, { desc = "inside code cell" })
vim.keymap.set({ "x", "o" }, "ab", function()
  textobject_select.select_textobject("@code_cell.outer", "textobjects")
end, { desc = "around code cell" })

vim.lsp.log.set_level("ERROR")

keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
-- Navigation is handled by Snacks pickers; keep core LSP maps minimal here
keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>")
keymap("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "<space>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { noremap = true })
keymap("n", "<space>wa", ":lua vim.lsp.buf.add_workspace_folder()")
keymap("n", "<space>rn", ":lua vim.lsp.buf.rename()<CR>")
keymap("n", "<space>ca", ":lua vim.lsp.buf.code_action()<CR>")
keymap("n", "<space>td", ":lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "<space>fm", function()
  local filetype = vim.bo.filetype

  -- Skip formatting for Python files
  if filetype == "python" then
    vim.notify("Skipping formatting for Python files", vim.log.levels.INFO)
    return
  end

  vim.lsp.buf.format({ async = true })
end, { noremap = true })

-- neodev
-- IMPORTANT: make sure to setup neodev BEFORE LSP config
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- mason setup (lsp config)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "jdtls",
    "gopls",
    "pylsp",
    "clangd",
  },
  automatic_enable = false,
})

-- Shared LSP capabilities for completion/snippets
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local navbuddy = require("nvim-navbuddy")
navbuddy.setup({
  window = {
    border = "single", -- "rounded", "double", "solid", "none"
    -- or an array with eight chars building up the border in a clockwise fashion
    -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
    size = "80%", -- Or table format example: { height = "40%", width = "100%"}
  },
})

local function attach_navbuddy(client, bufnr)
  navbuddy.attach(client, bufnr)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("gopls", {
  on_attach = attach_navbuddy,
  cmd = { "gopls" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedfunc = true,
      },
      directoryFilters = { "-node_modules", "-.git" },
    },
    staticcheck = true,
  },
})

vim.lsp.config("pylsp", {
  cmd = { "/Users/dexian/miniconda3/bin/pylsp" },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pylint = {
          enabled = true,
          args = { "--disable=C0116,C0114" },
        },
      },
    },
  },
  on_attach = attach_navbuddy,
})

-- JavaScript / TypeScript
vim.lsp.config("ts_ls", {
  on_attach = attach_navbuddy,
  init_options = {
    preferences = {
      disableSuggestions = false,
    },
  },
  settings = {
    typescript = {
      format = { enable = false },
      preferences = {
        quotePreference = "single",
        importModuleSpecifier = "relative",
      },
    },
    javascript = {
      format = { enable = false },
      preferences = {
        quotePreference = "single",
        importModuleSpecifier = "relative",
      },
    },
  },
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
})

local clangd_capabilities = vim.tbl_deep_extend("force", {}, capabilities, {
  offsetEncoding = { "utf-16" },
})
vim.lsp.config("clangd", {
  cmd = { "clangd", "--offset-encoding=utf-16", "--background-index" },
  capabilities = clangd_capabilities,
})

vim.lsp.enable({ "gopls", "pylsp", "lua_ls", "rust_analyzer", "ts_ls", "clangd", "jdtls" })

vim.diagnostic.config({ virtual_text = false, float = { border = "single" } })
vim.o.updatetime = 250
local diag_float = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = diag_float,
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

require("sniprun").setup({
  interpreter_options = {
    Go_original = {
      compiler = "gccgo",
    },
  },
})

-- default configuration
require("illuminate").configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    "regex",
  },
  -- delay: delay in milliseconds
  delay = 100,
  -- filetype_overrides: filetype specific overrides.
  -- The keys are strings to represent the filetype while the values are tables that
  -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
  filetype_overrides = {},
  -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
  filetypes_denylist = {
    "dirvish",
    "fugitive",
  },
  -- under_cursor: whether or not to illuminate under the cursor
  under_cursor = true,
  -- min_count_to_highlight: minimum number of matches required to perform highlighting
  min_count_to_highlight = 1,
})
