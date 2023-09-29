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
  { "nvim-tree/nvim-tree.lua", version = "*", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "akinsho/bufferline.nvim", version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  -- Quality of Life stuff
  'tpope/vim-sensible',   -- nice defaults to always have
  'tpope/vim-fugitive',   -- git wrapper
  'tpope/vim-repeat',     -- improves `.` repeating
  'tpope/vim-endwise',    -- automatically adds `end` to ruby methods
  'tpope/vim-commentary', -- gcc comment line; gc[target]
  'tpope/vim-surround',   -- [c]hange [s]urround
  'tpope/vim-obsession',  -- saves session before exit

  -- TMUX integration
  'christoomey/vim-tmux-navigator', -- allow C-hjkl to navigate between tmux panes
  'tpope/vim-tbone',                -- lets you call tmux commands from vim

  -- Languages and Frameworks support
  { 'tpope/vim-rails',     ft = 'ruby' },
  { 'tpope/vim-dispatch',  ft = 'ruby' },
  { 'vim-ruby/vim-ruby',   ft = 'ruby' },
  { 'noprompt/vim-yardoc', ft = 'ruby' },

  -- COLORS
  -- 'ayu-theme/ayu-vim',
  -- { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
  { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },

  -- Miscellaneous
  'github/copilot.vim'
}, {})

