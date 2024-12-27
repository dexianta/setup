function ColorScheme()
  require("rose-pine").setup({
    --- @usage 'auto'|'main'|'moon'|'dawn'
    variant = "moon",
  })
  require('catppuccin').setup({
    flavour = 'macchiato'
  })
  vim.cmd("colorscheme rose-pine")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorScheme()
