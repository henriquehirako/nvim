return {
  { 'tpope/vim-rails',     ft = 'ruby' },
  { 'vim-ruby/vim-ruby',   ft = 'ruby' },
  { 'noprompt/vim-yardoc', ft = 'ruby' },
  { 'fatih/vim-go',        ft = 'go' },
  { 'towolf/vim-helm',     ft = { 'helm', 'yaml' } },

  {
    -- Drives TypeScript instead of ts_ls, which is excluded from
    -- mason-lspconfig's automatic_enable in lsp.lua for that reason.
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {},
  },
}
