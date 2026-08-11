return {
  { 'tpope/vim-rails',     ft = 'ruby' },
  { 'vim-ruby/vim-ruby',   ft = 'ruby' },
  { 'noprompt/vim-yardoc', ft = 'ruby' },
  { 'fatih/vim-go',        ft = 'go' },
  { 'towolf/vim-helm',     ft = { 'helm', 'yaml' } },

  -- TypeScript has no plugin here on purpose: typescript-tools.nvim and ts_ls
  -- are both tsserver.js wrappers, and TypeScript 7 (the Go port) does not ship
  -- tsserver.js. The native binary speaks LSP directly, so it is configured as
  -- the `tsgo` server in lua/plugins/lsp.lua with no plugin in between.
}
