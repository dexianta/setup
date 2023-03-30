-------
-- global config
------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nv = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

nv("set number")
nv("set relativenumber")
nv("set t_Co=256")
nv("set autowriteall")
nv("set encoding=UTF-8")
nv("set shiftwidth=2")
nv("set softtabstop=2")
nv("set tabstop=2")
nv("set expandtab")
nv("set smartindent")
nv("set guicursor=")
nv("set nowrap")
nv("set smartcase")
nv("set incsearch")
--nv('set hlsearch')
nv("set noswapfile")
nv("set hidden")
nv("set scrolloff=8")
nv("set updatetime=100")
nv("set nofoldenable")
nv("set foldlevel=99")
nv("syntax on")
nv("set nocompatible")
nv("filetype plugin on")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

------------
-- packer
------------
require("packer").startup(function()
  use("wbthomason/packer.nvim")
  use("itchyny/lightline.vim")
  use("nvim-telescope/telescope-fzf-native.nvim")

  use("BurntSushi/ripgrep")
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
  })
  use({ "lewis6991/gitsigns.nvim" })

  -- lsp etc
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use({
    "williamboman/mason.nvim",
    run = ":MasonUpdate", -- :MasonUpdate updates registry contents
  })
  use({
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  })
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")

  -- snippet
  use("hrsh7th/vim-vsnip")
  use("hrsh7th/cmp-vsnip")

  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- vimwiki
  use("vimwiki/vimwiki")

  -- file browsing
  use("nvim-telescope/telescope-file-browser.nvim")

  -- nvim tree
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    tag = "nightly",              -- optional, updated every week. (see issue #1193)
  })

  -- formatter / linter (should be after tree sitter)
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("null-ls").setup()
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })
  -- debugger
  use("mfussenegger/nvim-dap")
  use("leoluz/nvim-dap-go")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")
  use("nvim-telescope/telescope-dap.nvim")
  use("folke/neodev.nvim")

  -- grammar checking because I can't english
  use("rhysd/vim-grammarous")
  use("f3fora/cmp-spell")

  -- highlight
  use("RRethy/vim-illuminate")
  -- trouble
  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup({})
    end,
  })

  -- color schemes
  use("sainnhe/everforest")
  use("arzg/vim-colors-xcode")
  use({ "catppuccin/nvim", as = "catppuccin" })
  use({ "folke/tokyonight.nvim" })
  use({ "bluz71/vim-moonfly-colors", branch = "cterm-compat" })
end)

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.g["lightline"] = {
  active = { left = { { "mode", "paste" }, { "readonly", "absolutepath", "modified" } } },
}

------------
-- LSP
------------
require("nvim-treesitter.configs").setup({
  ensure_installed = { "go", "c", "bash", "html", "python" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

local function nkeymap(key, map)
  local opts = { noremap = true }
  keymap("n", key, map, opts)
end

keymap("i", "<C-s>", "<ESC> <Space>fm :wa<CR> :NvimTreeRefresh<CR>", { noremap = false })
keymap("n", "<C-s>", "<Space>fm :wa<CR> :NvimTreeRefresh<CR>", { noremap = false })
keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
nkeymap("gd", ":lua vim.lsp.buf.definition()<CR>")
nkeymap("gD", ":lua vim.lsp.buf.declaration()<CR>")
nkeymap("gi", ":lua vim.lsp.buf.implementation()<CR>")
nkeymap("gr", ":lua vim.lsp.buf.references()<CR>")
nkeymap("K", ":lua vim.lsp.buf.hover()<CR>")
nkeymap("<C-k>", ":lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "<space>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { noremap = true })
nkeymap("<C-k>", ":lua vim.lsp.buf.signature_help()<CR>")
nkeymap("<space>wa", ":lua vim.lsp.buf.add_workspace_folder()")
nkeymap("<space>rn", ":lua vim.lsp.buf.rename()<CR>")
nkeymap("<space>ca", ":lua vim.lsp.buf.code_action()<CR>")
nkeymap("<space>td", ":lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "<space>fm", function()
  vim.lsp.buf.format({ async = true })
end, { noremap = true })
nkeymap("<space>gs", ":! git status<CR>")
nkeymap("<space>ff", ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>")
nkeymap("<space>fg", ":lua require('telescope.builtin').live_grep()<CR>")
nkeymap("gR", "<cmd>TroubleToggle lsp_references<CR>")

---------------
-- draw quick separate line
---------------
nkeymap("<C-l>l", "15i-<ESC>")

-------------
-- vimrc
-------------
nkeymap("<C-v>e", ":e $MYVIMRC<CR>")
nkeymap("<C-v>s", ":so $MYVIMRC<CR>")

nkeymap("<space>dr", ":NvimTreeToggle<CR>")
nkeymap("<space>df", ":NvimTreeFindFile<CR>")

---------------
-- highlight
---------------
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

-------------
-- gitsign
-------------
require("gitsigns").setup({
  signs = {
    add = { hl = "GitSignsAdd", text = "‖", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    untracked = { hl = "GitSignsAdd", text = "┆", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true,     -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,   -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  yadm = {
    enable = false,
  },
})

-------------
-- toggleterm
-------------
require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  direction = "horizontal",
})

-------------
-- CMP
-------------
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip.loaders.from_vscode").lazy_load()
local luasnip = require("luasnip")
local cmp = require("cmp")
vim.opt.completeopt = { "menu", "menuone", "noselect" }
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "luasnip" },
    {
      name = "spell",
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    },
    { name = "buffer" },
  }),
  experimental = {
    ghost_text = true,
  },
})

function leave_snippet()
  if
      ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
      and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
  then
    require("luasnip").unlink_current()
  end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua leave_snippet()
]])

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- neodev
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- mason setup (lsp config)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "gopls" },
})

local null_ls = require("null-ls")
null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.code_actions.gomodifytags,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.diagnostics.golangci_lint,
  },
})

-- Set up lspconfig.
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({
  cmd = { "gopls" },
  capabilities = capabilities,
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
lspconfig.lua_ls.setup({})

-------------
-- nvim tree
-------------
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
    relativenumber = true,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        git = true,
        folder = false,
        file = false,
        folder_arrow = true,
      },
    },
  },
})

nkeymap("<Leader>cb", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
nkeymap("<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
nkeymap("<Leader>u", ":lua require'dapui'.toggle()<CR>")
nkeymap("<Leader>t", ":lua require'dap-go'.debug_test()<CR>")
nkeymap("<Leader>c", ":lua require'dap'.continue()<CR>")
nkeymap("<Leader>l", ":lua require'dap'.run_last()<CR>")
nkeymap("<Leader>n", ":lua require'dap'.step_over()<CR>")
nkeymap("<Leader>i", ":lua require'dap'.step_into()<CR>")
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

-------------
-- telescope
-------------
require("telescope").setup({
  pickers = {
    current_buffer_fuzzy_find = { sorting_strategy = "ascending" },
  },
})

-------------
-- English check
-------------
vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

------------
-- color scheme (seems to start at the end)
------------
vim.cmd([[colorscheme catppuccin]])
