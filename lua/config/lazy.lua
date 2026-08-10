local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Migrated plugins live one-per-file in lua/plugins/, where the spec and its
  -- configuration sit together. Entries below are still awaiting that move.
  { import = 'plugins' },

  -- NVIM specific
  { 'nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
  -- { 'nvim-treesitter/playground' }, -- replaced by :InspectTree in Neovim 0.12+

  -- Quality of Life stuff
  'tpope/vim-sensible',   -- nice defaults to always have
  'tpope/vim-fugitive',   -- git wrapper
  'tpope/vim-repeat',     -- improves `.` repeating
  'tpope/vim-endwise',    -- automatically adds `end` to ruby methods
  'tpope/vim-commentary', -- gcc comment line; gc[target]
  'tpope/vim-surround',   -- [c]hange [s]urround
  'tpope/vim-obsession',  -- saves session before exit
  'tpope/vim-dispatch',   -- async job dispatcher

  -- TMUX integration
  'christoomey/vim-tmux-navigator', -- allow C-hjkl to navigate between tmux panes
  'tpope/vim-tbone',                -- lets you call tmux commands from vim

  -- Focus mode
  { 'shortcuts/no-neck-pain.nvim', version = '*' },

  -- Languages and Frameworks support
  { 'tpope/vim-rails',     ft = 'ruby' },
  { 'vim-ruby/vim-ruby',   ft = 'ruby' },
  { 'noprompt/vim-yardoc', ft = 'ruby' },
  { 'fatih/vim-go',        ft = 'go' },
  { 'towolf/vim-helm' },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },

  -- cmp pluggins
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/cmp-nvim-lsp',
  'onsails/lspkind.nvim',
  'zbirenbaum/copilot-cmp',

  -- LSP
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',

  -- COLORS
  { 'projekt0n/github-nvim-theme', lazy = false, priority = 1000 },
  { 'tinted-theming/base16-vim', },
  { 'jeffkreeftmeijer/vim-dim', },

  -- Miscellaneous
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp'
    },
  }

  -- 'github/copilot.vim',
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = {
  --     { 'nvim-lua/plenary.nvim', branch = 'master' },
  --   },
  --   build = 'make tiktoken',
  --   opts = {
  --     -- See Configuration section for options
  --   },
  -- },

-- 'Exafunction/codeium.vim'
}, {})

