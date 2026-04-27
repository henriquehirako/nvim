local status, ts = pcall(require, "nvim-treesitter")
if (not status) then return end

-- nvim-treesitter main branch (Neovim 0.12+) API
-- setup() only accepts install_dir now
ts.setup {}

-- Install parsers (no-op if already installed)
ts.install { "lua", "vim", "markdown", "vimdoc", "query", "ruby", "javascript", "typescript", "tsx", "json" }

-- Enable tree-sitter highlighting per filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'vim', 'markdown', 'vimdoc', 'query', 'ruby', 'javascript', 'typescript', 'tsx', 'json' },
  callback = function()
    vim.treesitter.start()
  end,
})
