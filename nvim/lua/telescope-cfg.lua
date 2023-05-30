keymap("n", "<space>ff", ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>")
keymap("n", "<space>lr", ":lua require('telescope.builtin').lsp_references()<CR>")
keymap("n", "<space>fg", ":lua require('telescope.builtin').live_grep()<CR>")
