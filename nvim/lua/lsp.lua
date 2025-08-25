require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "sql",
    "vimdoc",
    "javascript",
    "typescript",
    "go",
    "c",
    "bash",
    "html",
    "python",
    "markdown",
  },
  auto_install = true,
  sync_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>")
keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>")
keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>")
keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>")
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
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- mason setup (lsp config)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "gopls",
    "pylsp",
    "clangd",
  },
})

local null_ls = require("null-ls")
null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    -- null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.golangci_lint,
  },
})

-- Set up lspconfig.
local navbuddy = require("nvim-navbuddy")
navbuddy.setup({
  window = {
    border = "single", -- "rounded", "double", "solid", "none"
    -- or an array with eight chars building up the border in a clockwise fashion
    -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
    size = "80%", -- Or table format example: { height = "40%", width = "100%"}
  },
})

local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
  on_attach = function(client, bufnr)
    navbuddy.attach(client, bufnr)
  end,
  cmd = { "gopls" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        unusedfunc = true,
      },
    },
    staticcheck = true,
  },
})
lspconfig.pylsp.setup({
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
  on_attach = function(client, bufnr)
    navbuddy.attach(client, bufnr)
  end,
})

lspconfig.lua_ls.setup({})
lspconfig.rust_analyzer.setup({})
-- JavaScript / TypeScript
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    navbuddy.attach(client, bufnr)
  end,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({
  capabilities = capabilities,
})

vim.diagnostic.config({ virtual_text = false })
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

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
    "lsp",
    "treesitter",
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
