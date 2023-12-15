require("packer").startup(function()
  use("wbthomason/packer.nvim")
  use("itchyny/lightline.vim")
  use("nvim-telescope/telescope-fzf-native.nvim")

  use("BurntSushi/ripgrep")
  use({
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
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
  use("onsails/lspkind-nvim")
  use({
    "SmiteshP/nvim-navbuddy",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      "numToStr/Comment.nvim",         -- Optional
      "nvim-telescope/telescope.nvim", -- Optional
    },
  })
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
    tag = "nightly",                 -- optional, updated every week. (see issue #1193)
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
  use({
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    }
  })
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
  use({ "rose-pine/neovim", as = "rose-pine" })

  -- run code
  use({ "michaelb/sniprun", run = "bash ./install.sh" })
end)
