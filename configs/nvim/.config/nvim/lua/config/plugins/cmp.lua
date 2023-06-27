local status, plugin = pcall(require, "cmp")
if (not status) then return end

local status, lspkind = pcall(require, "lspkind")
if (not status) then return end

local function format_completion_menu(entry, vim_item)
  if entry.completion_item.detail and entry.completion_item.detail then
    vim_item.menu = entry.completion_item.detail
  else
    vim_item.menu = ({
      nvim_lsp = "[LSP]",
      luasnip = "[Snippet]",
      buffer = "[Buffer]",
      path = "[Path]",
    })[entry.source.name]
  end

  return vim_item
end

plugin.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = plugin.mapping.preset.insert({
    ['<C-d>'] = plugin.mapping.scroll_docs(-4),
    ['<C-f>'] = plugin.mapping.scroll_docs(4),
    ['<C-Space>'] = plugin.mapping.complete(),
    ['<C-e>'] = plugin.mapping.close(),
    ['<CR>'] = plugin.mapping.confirm({
      behavior = plugin.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = plugin.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
      before = format_completion_menu
    })
  }
})

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]