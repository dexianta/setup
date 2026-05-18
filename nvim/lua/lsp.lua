require("nvim-treesitter.configs").setup({
  ensure_installed = {
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
  },
  auto_install = true,
  sync_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ib"] = { query = "@code_cell.inner", desc = "inside code cell" },
        ["ab"] = { query = "@code_cell.outer", desc = "around code cell" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]b"] = { query = "@code_cell.inner", desc = "next code cell" },
      },
      goto_previous_start = {
        ["[b"] = { query = "@code_cell.inner", desc = "previous code cell" },
      },
    },
  },
})

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
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
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
})

-- Shared LSP capabilities for completion/snippets
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

local function attach_navbuddy(client, bufnr)
  navbuddy.attach(client, bufnr)
end

local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
  on_attach = attach_navbuddy,
  capabilities = capabilities,
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
lspconfig.pylsp.setup({
  cmd = { "/Users/dexian/miniconda3/bin/pylsp" },
  capabilities = capabilities,
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

lspconfig.lua_ls.setup({ capabilities = capabilities })
lspconfig.rust_analyzer.setup({ capabilities = capabilities })
-- JavaScript / TypeScript
lspconfig.tsserver.setup({
  on_attach = attach_navbuddy,
  capabilities = capabilities,
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
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
})

local clangd_cap = vim.lsp.protocol.make_client_capabilities()
clangd_cap.offsetEncoding = { "utf-16" }
require("lspconfig").clangd.setup({
  cmd = { "clangd", "--offset-encoding=utf-16", "--background-index" },
  capabilities = vim.tbl_deep_extend("force", capabilities, clangd_cap),
})

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
