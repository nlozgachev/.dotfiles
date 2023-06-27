local status, plugin = pcall(require, "tokyonight")
if (not status) then return end

plugin.setup({
  style = "night",
})

vim.cmd [[colorscheme tokyonight]]
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
