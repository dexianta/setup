require("global")
require("packer_cfg")
require("lsp")
require("dap-cfg")
require("cmp-cfg")
require("nvtree")
require("spellcheck")
require('gitsign-cfg')
require('toggleterm-cfg')
require("telescope").setup({
  pickers = {
    current_buffer_fuzzy_find = { sorting_strategy = "ascending" },
  },
})

require("misc")
require("colortheme")
