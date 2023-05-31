keymap("n", "<space>ff", ":lua require('telescope.builtin').find_files({hidden=true, no_ignore=true})<CR>")
keymap("n", "<space>lg", ":lua require('telescope.builtin').live_grep()<CR>")
keymap("n", "<space>gs", ":lua require('telescope.builtin').grep_string()<CR>")
keymap("n", "<space>gf", ":lua require('telescope.builtin').git_files()<CR>")
