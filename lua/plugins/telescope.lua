-- Shared ripgrep flags: show hidden files, follow symlinks, but never descend
-- into .git. Respects .gitignore by default.
local rg_common = { '--hidden', '--follow', '--glob', '!.git/*' }

local function builtin(name, opts)
  return function()
    require('telescope.builtin')[name](opts or {})
  end
end

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = 'Telescope',
  keys = {
    {
      '<C-p>',
      builtin('find_files', {
        hidden = true,
        find_command = vim.list_extend({ 'rg', '--files' }, rg_common),
      }),
      desc = 'Find files',
    },
    { '<leader>g', builtin('git_files'), desc = 'Git files' },
    { '<leader>f', builtin('live_grep'), desc = 'Live grep' },
    { '<leader>b', builtin('buffers'), desc = 'Buffers' },
    { '<leader>h', builtin('help_tags'), desc = 'Help tags' },
  },
  opts = function()
    local actions = require('telescope.actions')

    return {
      defaults = {
        vimgrep_arguments = vim.list_extend({
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        }, rg_common),
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },
    }
  end,
}
