local status_main, plugin_main = pcall(require, "mason")
if (not status_main) then return end

local status_config, plugin_config = pcall(require, "mason-lspconfig")
if (not status_config) then return end

plugin_main.setup({})
plugin_config.setup {
  ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" },

  automatic_installation = true
}
