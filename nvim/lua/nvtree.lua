keymap("n", "<space>dr", ":NvimTreeToggle<CR>")
keymap("n", "<space>df", ":NvimTreeFindFile<CR>")

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
    relativenumber = true,
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
