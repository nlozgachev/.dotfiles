local status, plugin = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

plugin.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "html",
    "css",
    "scss",
    "tsx",
    "typescript",
    "fish",
    "bash",
    "go",
    "rust",
    "python",
    "glsl",
    "svelte",
    "markdown",
    "toml",
    "json",
    "yaml",
    "lua",
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
