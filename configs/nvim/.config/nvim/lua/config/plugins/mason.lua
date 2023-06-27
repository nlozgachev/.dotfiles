local status, plugin = pcall(require, "mason")
if (not status) then return end

plugin.setup({})
