require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "vimdoc",
    "javascript",
    "typescript",
    "go",
    "c",
    "bash",
    "html",
    "python",
  },
  auto_install = true,
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
  vim.lsp.buf.format({ async = true })
end, { noremap = true })
keymap("n", "gR", "<cmd>TroubleToggle lsp_references<CR>")

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
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})
lspconfig.pylsp.setup({
  on_attach = function(client, bufnr)
    navbuddy.attach(client, bufnr)
  end,
})
lspconfig.pyre.setup({})
lspconfig.lua_ls.setup({})
lspconfig.rust_analyzer.setup({})

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
