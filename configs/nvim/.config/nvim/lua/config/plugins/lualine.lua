local status, plugin = pcall(require, "lualine")
if (not status) then return end

plugin.setup {
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
  },
}
