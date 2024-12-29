-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  -- mason
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- Telescope and dependencies
  {
    'nvim-telescope/telescope-fzf-native.nvim', build = 'make'
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.7",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  "nvim-telescope/telescope-file-browser.nvim",
  "BurntSushi/ripgrep",

  -- Fidget
  "j-hui/fidget.nvim",

  -- ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Treesitter and related plugins
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Mason and LSP configuration
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
  },
  "williamboman/mason-lspconfig.nvim",
  {
    "neovim/nvim-lspconfig",
    config = function()
      local on_attach = function(client, bufnr)
        local buf_map = vim.api.nvim_buf_set_keymap
        local opts = { noremap = true, silent = true }

        buf_map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
      end

      require("lspconfig").pyright.setup({
        on_attach = on_attach,
      })
    end,
  },

  -- Completion plugins
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "onsails/lspkind-nvim",

  -- Navbuddy
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  -- Snippet plugins
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- Vimwiki
  "vimwiki/vimwiki",

  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    version = "v1.9.0",
    lazy = false,
  },

  -- Formatter / Linter
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.diagnostics.eslint,
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Debugging
  "mfussenegger/nvim-dap",
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },
  "leoluz/nvim-dap-go",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "nvim-telescope/telescope-dap.nvim",

  -- Neodev
  "folke/neodev.nvim",

  -- Grammar and spell-checking
  {
    "rhysd/vim-grammarous",
    lazy = true,
  },
  {
    "f3fora/cmp-spell",
    lazy = true,
  },

  -- Highlighting
  "RRethy/vim-illuminate",

  -- Trouble plugin
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
    end,
  },

  -- Color schemes
  { "rose-pine/neovim", name = "rose-pine" },

  -- Code runner
  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
  },

  -- Git plugins
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Neotest
  "nvim-neotest/nvim-nio",
})
