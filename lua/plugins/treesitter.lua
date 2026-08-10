-- One list, used for both parser installation and the highlighting autocmd.
-- These were two separate literals before, which had to be kept in sync by hand.
local languages = {
  'lua',
  'vim',
  'markdown',
  'vimdoc',
  'query',
  'ruby',
  'javascript',
  'typescript',
  'tsx',
  'json',
}

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  -- BufReadPre rather than BufReadPost: the FileType autocmd registered below
  -- has to exist before filetype detection fires for the first buffer.
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local ok, ts = pcall(require, 'nvim-treesitter')
    if not ok then return end

    -- main branch (Neovim 0.12+): setup() only accepts install_dir, and parsers
    -- are installed via ts.install rather than an `ensure_installed` option.
    ts.setup {}
    ts.install(languages) -- no-op for parsers already installed

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
      pattern = languages,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- The buffer that triggered this load has already had its FileType fire, so
    -- start highlighting on it directly.
    if vim.tbl_contains(languages, vim.bo.filetype) then
      pcall(vim.treesitter.start)
    end
  end,
}
