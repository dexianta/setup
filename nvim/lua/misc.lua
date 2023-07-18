---------------
-- restart lsp server
---------------
keymap("n", "<C-l>r", ":LspStop<CR> :LspStart<CR>")

---------------
-- draw quick separate line
---------------
keymap("n", "<C-l>l", "15i=<ESC>")

-------------
-- vimrc
-------------
keymap("n", "<C-v>e", ":e $MYVIMRC<CR>")
keymap("n", "<C-v>s", ":so $MYVIMRC<CR>")

vim.api.nvim_set_keymap("i", "<C-s>", "<ESC> <Space>fm :wa<CR> :NvimTreeRefresh<CR>", { noremap = false })
vim.api.nvim_set_keymap("n", "<C-s>", "<Space>fm :wa<CR> :NvimTreeRefresh<CR>", { noremap = false })

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.g["lightline"] = {
  active = { left = { { "mode", "paste" }, { "readonly", "absolutepath", "modified" } } },
}
