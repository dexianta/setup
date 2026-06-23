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
      web_devicons = {
        file = { enable = false },
        folder = { enable = false },
      },
      show = {
        git = false,
        folder = true,
        file = false,
        folder_arrow = false,
      },
      glyphs = {
        folder = {
          default = "-",
          open = "-",
          empty = "-",
          empty_open = "-",
          symlink = "-",
          symlink_open = "-",
        },
      },
    },
  },
})
