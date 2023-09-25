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

require("lazy").setup({
  -- NVIM specific
  { 'nvim-telescope/telescope.nvim', tag = '0.1.3', dependencies = { 'nvim-lua/plenary.nvim' } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/playground" },
  { "akinsho/bufferline.nvim", version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Quality of Life stuff
  'tpope/vim-sensible',   -- nice defaults to always have
  'tpope/vim-fugitive',   -- git wrapper
  'tpope/vim-repeat',     -- improves `.` repeating
  'tpope/vim-endwise',    -- automatically adds `end` to ruby methods
  'tpope/vim-commentary', -- gcc comment line; gc[target]
  'tpope/vim-surround',   -- [c]hange [s]urround
  'tpope/vim-obsession',  -- saves session before exit

  -- Languages and Frameworks support
  { 'tpope/vim-rails', ft = 'ruby' },
  { 'tpope/vim-dispatch', ft = 'ruby' },

  -- COLORS
  -- 'ayu-theme/ayu-vim',
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

  -- Miscellaneous
  'github/copilot.vim'
}, {})

