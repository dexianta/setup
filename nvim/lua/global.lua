vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvcmd = vim.api.nvim_command
nvcmd("set number")
nvcmd("set list listchars=space:·")
nvcmd("set relativenumber")
nvcmd("set t_Co=256")
nvcmd("set autowriteall")
nvcmd("set encoding=UTF-8")
nvcmd("set shiftwidth=2")
nvcmd("set softtabstop=2")
nvcmd("set tabstop=2")
nvcmd("set expandtab")
nvcmd("set smartindent")
nvcmd("set guicursor=")
nvcmd("set nowrap")
nvcmd("set smartcase")
nvcmd("set incsearch")
nvcmd("set noswapfile")
nvcmd("set hidden")
nvcmd("set scrolloff=8")
nvcmd("set updatetime=100")
nvcmd("set nofoldenable")
nvcmd("set foldlevel=99")
nvcmd("syntax on")
nvcmd("set nocompatible")
nvcmd("filetype plugin on")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

function keymap(mode, key, map)
  local opts = { noremap = true }
  vim.api.nvim_set_keymap(mode, key, map, opts)
end
