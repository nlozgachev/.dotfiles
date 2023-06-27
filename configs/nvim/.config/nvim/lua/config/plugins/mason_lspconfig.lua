local status, plugin = pcall(require, "mason-lspconfig")
if (not status) then return end

plugin.setup {
  ensure_installed = { "lua_ls", "rust_analyzer", "tsserver" },

  automatic_installation = true
}

