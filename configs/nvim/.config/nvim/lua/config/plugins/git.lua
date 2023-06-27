local status, plugin = pcall(require, "git")
if (not status) then return end

plugin.setup({
  keymaps = {
    -- blame = "<Leader>gb", -- Open blame window
    -- browse = "<Leader>go", -- Open file/folder in git repository
  }
})