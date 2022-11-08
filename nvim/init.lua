------------
-- global config
------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nv = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

nv('set number')
nv('set t_Co=256')
nv('set autowriteall')
nv('set encoding=UTF-8')
nv('set shiftwidth=4')
nv('set softtabstop=4')
nv('set expandtab')
nv('set smartindent')
nv('set guicursor=')
nv('set nowrap')
nv('set smartcase')
nv('set incsearch')
nv('set hlsearch')
nv('set noswapfile')
nv('set hidden')
nv('set scrolloff=8')
nv('set updatetime=100')
nv('set nofoldenable')
nv('set foldlevel=99')
nv('syntax on')
nv('set nocompatible')
nv('filetype plugin on')

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

------------
-- packer
------------
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'itchyny/lightline.vim'
    use 'arzg/vim-colors-xcode'
    use {
        "sonph/onehalf",
        rtp = "vim/",
    }
    use 'nvim-telescope/telescope-fzf-native.nvim'

    use 'nvim-lua/plenary.nvim'
    use 'BurntSushi/ripgrep'
    use 'nvim-telescope/telescope.nvim'
    use {
        'akinsho/toggleterm.nvim',
        tag = '*'
    }
    use {'lewis6991/gitsigns.nvim'}
    -- IDE
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'

    -- snippet
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-vsnip'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'


    use 'vimwiki/vimwiki'

    -- file browsing
    use 'nvim-telescope/telescope-file-browser.nvim'

    -- nvim tree
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    -- debugger
    use 'mfussenegger/nvim-dap'
    use 'leoluz/nvim-dap-go'
    use 'rcarriga/nvim-dap-ui'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'nvim-telescope/telescope-dap.nvim'

    -- grammar checking because I can't english
    use 'rhysd/vim-grammarous'
    use 'f3fora/cmp-spell'
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
end)

vim.g['lightline'] = {
    active = {left = {{ 'mode', 'paste' }, { 'readonly', 'absolutepath', 'modified' }}}
}


------------
-- LSP
------------
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { 'go', 'c', 'bash', 'lua', 'html', 'python' },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    }
}

require('nvim-lsp-installer').on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)


local function nkeymap(key, map)
    local opts = { noremap = true }
    keymap('n', key, map, opts)
end

-------------
-- key mapping
-------------
keymap('t', '<Esc>', "<C-\\><C-n>", { noremap = true })
nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { noremap = true })
nkeymap('<space>wa', ':lua vim.lsp.buf.add_workspace_folder()')
nkeymap('<space>rn', ':lua vim.lsp.buf.rename()<cr>')
nkeymap('<space>ca', ':lua vim.lsp.buf.code_action()<cr>')
nkeymap('<space>td', ':lua vim.lsp.buf.type_definition()<cr>')
vim.keymap.set('n', '<space>fm', function() vim.lsp.buf.format { async = true } end, { noremap = true })
nkeymap('<C-k>', ':lua vim.lsp.buf.signature_help()<cr>')
nkeymap('<space>gs', ':! git status<cr>')
nkeymap('<space>ff', ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<cr>")
nkeymap('<space>fg', ":lua require('telescope.builtin').live_grep()<cr>")

nkeymap('<space>dr', ":NvimTreeToggle<cr>")
nkeymap('<space>df', ":NvimTreeFindFile<cr>")



-------------
-- gitsign  
-------------
require('gitsigns').setup {
  signs = {
    add          = { hl = 'GitSignsAdd'   , text = '‖', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
    change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
    untracked    = { hl = 'GitSignsAdd'   , text = '┆', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'    },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

-------------
-- toggleterm
-------------
require('toggleterm').setup {
    size = function(term)
        if term.direction == 'horizontal' then
            return 15
        elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
        end
    end,
    open_mapping = [[<c-\>]],
    direction = 'horizontal',
}


-------------
-- CMP
-------------

require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = { "menu", "menuone", "noselect" }
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        {
            name = 'spell',
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
            },
        },
        { name = 'buffer' },
    }),
    experimental = {
        ghost_text = true
    }
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['gopls'].setup {
    capabilities = capabilities,
}


-------------
-- nvim tree
-------------
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
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

nkeymap("<space>n", ":lua require'dap'.step_over()<CR>")
nkeymap("<space>dq", ":lua require'dap'.()<CR>")
nkeymap("<space>si", ":lua require'dap'.step_into()<CR>")
nkeymap("<space>b", ":lua require'dap'.toggle_breakpoint()<CR>")
nkeymap("<silent><space>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
nkeymap("<space>c", ":lua require'dap'.continue()<CR>")
nkeymap("<space>t", ":lua require'dap-go'.debug_test()<CR>")
nkeymap("<space>ui", ":lua require'dapui'.toggle()<CR>")
-------------
-- dap go
-------------
require('dap-go').setup()
require('dapui').setup()
require('nvim-dap-virtual-text').setup()

local dap, dapui = require('dap'), require('dapui')
dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    --dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end


-------------
-- English check
-------------
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }


------------
-- color scheme (seems to start at the end)
------------
vim.cmd [[colorscheme onehalfdark]]
