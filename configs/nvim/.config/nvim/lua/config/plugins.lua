local init_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = init_packer()

-- reload neovim on plugins.lua change
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  -- package manager
  use 'wbthomason/packer.nvim'

  -- plugin utilities
  use 'nvim-lua/plenary.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function() require('config.plugins.treesitter') end,
  }

  use {
    'williamboman/mason.nvim',
    config = function() require('config.plugins.mason') end,
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    config = function() require('config.plugins.mason_lspconfig') end,
  }

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function() require('config.plugins.lspconfig') end,
  }

  use {
    'onsails/lspkind-nvim',
    config = function() require('config.plugins.lspkind') end,
  }

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function() require('config.plugins.null_ls') end,
  }

  -- LSP UIs
  use {
    'glepnir/lspsaga.nvim',
    config = function() require('config.plugins.lspsaga') end,
  }

  -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-buffer'

  -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/cmp-nvim-lsp'

  -- completion
  use {
    'hrsh7th/nvim-cmp',
    config = function() require('config.plugins.cmp') end,
  }

  -- snippets
  use 'L3MON4D3/LuaSnip'

  use {
    'nvim-telescope/telescope.nvim',
    config = function() require('config.plugins.telescope') end,
  }
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'windwp/nvim-autopairs'
  use {
    'windwp/nvim-ts-autotag',
    config = function() require('config.plugins.ts_autotag') end,
  }

  use 'lewis6991/gitsigns.nvim'

  -- git blame & browse
  use {
    'dinhhuy258/git.nvim',
    config = function() require('config.plugins.git') end,
  }

  -- color scheme
  use {
    'folke/tokyonight.nvim',
    config = function() require('config.plugins.tokyonight') end
  }

  -- fancier status bar
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('config.plugins.lualine') end,
  }

  -- startup screen
  -- use {
  --   'goolord/alpha-nvim',
  --   -- config = function() require('config.plugins.alpha') end,
  -- }

  -- distraction-free writing mode
  -- use {
  --   'folke/zen-mode.nvim',
  --   opt = true,
  --   cmd = { 'ZenMode' },
  --   -- config = function() require('config.plugins.zen-mode') end
  -- }


  use { 'numToStr/Comment.nvim',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring'
    },
    config = function() require('config.plugins.comment') end
  }

  -- automatically set up the configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end

end)
