require("global")
require("lazy-cfg")
require("lsp")
require("dap-cfg")
require("cmp-cfg")
require("nvtree")
require("spellcheck")
require("gitsign-cfg")
--require("telescope").setup({
--  pickers = {
--    current_buffer_fuzzy_find = { sorting_strategy = "ascending" },
--  },
--})
--require("telescope-cfg")

require("misc")
require("colortheme")
tags = require("tags")
vim.cmd('command! -nargs=* AddTags lua tags.add_tags({<f-args>})')
