-- Parser names, which are NOT always filetype names -- a .tsx buffer has
-- filetype `typescriptreact` but is parsed by `tsx`. Highlighting used to be
-- driven by matching this list against filetypes directly, so every filetype
-- whose name differs from its parser (tsx, jsx, sh) silently went unhighlighted.
-- The FileType handler below resolves filetype -> parser instead of assuming
-- they match.
local parsers = {
  'lua',
  'vim',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'ruby',
  'javascript',
  'typescript',
  'tsx',
  'jsdoc',
  'json',
  'html',
  'css',
  'scss',
  'yaml',
  'toml',
  'graphql',
  'regex',
  'bash',
  'gitcommit',
  'diff',
}

-- Filetypes Neovim does not already map to a parser. Without these, get_lang()
-- returns the filetype unchanged and the parser lookup fails.
local filetype_parsers = {
  tsx = { 'typescriptreact' },
  javascript = { 'javascriptreact' },
  bash = { 'sh', 'zsh' },
  -- nvim-treesitter has no jsonc parser; the json one handles tsconfig.json and
  -- friends fine apart from comments.
  json = { 'jsonc', 'json5' },
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
    ts.install(parsers) -- no-op for parsers already installed

    for lang, filetypes in pairs(filetype_parsers) do
      vim.treesitter.language.register(lang, filetypes)
    end

    -- Start highlighting for any buffer whose filetype resolves to a parser that
    -- is actually installed, rather than matching against a hardcoded list that
    -- has to be kept in sync with the one above.
    local function start(buf, filetype)
      local lang = vim.treesitter.language.get_lang(filetype)
      if not lang then return end
      if not pcall(vim.treesitter.language.add, lang) then return end
      pcall(vim.treesitter.start, buf, lang)
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
      callback = function(ev)
        start(ev.buf, ev.match)
      end,
    })

    -- The buffer that triggered this load has already had its FileType fire.
    start(0, vim.bo.filetype)
  end,
}
