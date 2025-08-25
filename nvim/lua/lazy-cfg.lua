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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Telescope and dependencies
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.7",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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

  {
    'stevearc/aerial.nvim',
    opts = {},
    keys = {
      { "<Leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle Code Outline" },
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },

  -- Navbuddy
  {
    "hasansujon786/nvim-navbuddy",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      }
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
    -- "jose-elias-alvarez/null-ls.nvim",
    "nvimtools/none-ls.nvim",
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

  -- Debugging DAP
  "mfussenegger/nvim-dap",
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },
  "mfussenegger/nvim-dap-python",
  "leoluz/nvim-dap-go",
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
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
  { "rose-pine/neovim",     name = "rose-pine" },

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

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    'rebelot/kanagawa.nvim',
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Your config here
      })
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      --  bigfile = { enabled = true },
      dashboard = { enabled = true },
      --  explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      -- scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = { wrap = true } -- Wrap notifications
        }
      },
      terminal = {
      }
    },
    keys = {
      -- terminal
      { "<leader>T",       function() Snacks.terminal.toggle() end },
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,                  desc = "Grep" },
      --{ "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      --{ "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      --{ "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
      -- find
      { "<leader>fb",      function() Snacks.picker.buffers() end,               desc = "Buffers" },
      { "<leader>ff",      function() Snacks.picker.files() end,                 desc = "Find Files" },
      -- git
      --{ "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      --{ "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      --{ "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      --{ "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      --{ "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      --{ "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      --{ "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
      -- Grep
      { "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,          desc = "Grep Open Buffers" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                  desc = "Grep" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,             desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',      function() Snacks.picker.registers() end,             desc = "Registers" },
      { '<leader>s/',      function() Snacks.picker.search_history() end,        desc = "Search History" },
      { "<leader>sa",      function() Snacks.picker.autocmds() end,              desc = "Autocmds" },
      { "<leader>sb",      function() Snacks.picker.lines() end,                 desc = "Buffer Lines" },
      { "<leader>sc",      function() Snacks.picker.command_history() end,       desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,              desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,    desc = "Buffer Diagnostics" },
      { "<leader>sh",      function() Snacks.picker.help() end,                  desc = "Help Pages" },
      { "<leader>sH",      function() Snacks.picker.highlights() end,            desc = "Highlights" },
      { "<leader>si",      function() Snacks.picker.icons() end,                 desc = "Icons" },
      { "<leader>sj",      function() Snacks.picker.jumps() end,                 desc = "Jumps" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,               desc = "Keymaps" },
      { "<leader>sl",      function() Snacks.picker.loclist() end,               desc = "Location List" },
      { "<leader>sm",      function() Snacks.picker.marks() end,                 desc = "Marks" },
      { "<leader>sM",      function() Snacks.picker.man() end,                   desc = "Man Pages" },
      { "<leader>sp",      function() Snacks.picker.lazy() end,                  desc = "Search for Plugin Spec" },
      { "<leader>sq",      function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
      { "<leader>sR",      function() Snacks.picker.resume() end,                desc = "Resume" },
      { "<leader>su",      function() Snacks.picker.undo() end,                  desc = "Undo History" },
      { "<leader>uC",      function() Snacks.picker.colorschemes() end,          desc = "Colorschemes" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,       desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,      desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,   desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,  desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",       function() Snacks.zen() end,                          desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                     desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
      { "<leader>n",       function() Snacks.notifier.show_history() end,        desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                    desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,           desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                    desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>gg",      function() Snacks.lazygit() end,                      desc = "Lazygit" },
      { "<leader>un",      function() Snacks.notifier.hide() end,                desc = "Dismiss All Notifications" },
      { "<c-/>",           function() Snacks.terminal() end,                     desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,                     desc = "which_key_ignore" },
      { "]]",              function() Snacks.words.jump(vim.v.count1) end,       desc = "Next Reference",           mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end,      desc = "Prev Reference",           mode = { "n", "t" } },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    --  init = function()
    --    vim.api.nvim_create_autocmd("User", {
    --      pattern = "VeryLazy",
    --      callback = function()
    --        -- Setup some globals for debugging (lazy-loaded)
    --        _G.dd = function(...)
    --          Snacks.debug.inspect(...)
    --        end
    --        _G.bt = function()
    --          Snacks.debug.backtrace()
    --        end
    --        vim.print = _G.dd -- Override print to use snacks for `:=` command

    --        -- Create some toggle mappings
    --        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    --        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    --        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    --        Snacks.toggle.diagnostics():map("<leader>ud")
    --        Snacks.toggle.line_number():map("<leader>ul")
    --        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    --        Snacks.toggle.treesitter():map("<leader>uT")
    --        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    --        Snacks.toggle.inlay_hints():map("<leader>uh")
    --        Snacks.toggle.indent():map("<leader>ug")
    --        Snacks.toggle.dim():map("<leader>uD")
    --      end,
    --    })
    --  end,
  }
})
