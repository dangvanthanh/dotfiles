local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See :help mapleader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local plugins = {
  'ellisonleao/gruvbox.nvim',
  'L3MON4D3/LuaSnip',
  'kyazdani42/nvim-web-devicons',
  'hoob3rt/lualine.nvim',
  'onsails/lspkind-nvim',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/nvim-cmp',
  'neovim/nvim-lspconfig',
  'nvim-treesitter/nvim-treesitter',
  'MunifTanjim/prettier.nvim',
  'windwp/nvim-autopairs',
  'windwp/nvim-ts-autotag',
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },
  'lewis6991/gitsigns.nvim',
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    }
  }
}

local opts = {}

require('lazy').setup(plugins, opts);