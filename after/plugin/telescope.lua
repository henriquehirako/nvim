local builtin = require('telescope.builtin')

-- Show hidden files; respect .gitignore; exclude .git directory
local custom_find_files = ':Telescope find_files hidden=true find_command={"rg","--files","--hidden","--follow","--glob","!.git/*"} <CR>'
vim.keymap.set('n', '<C-p>', custom_find_files, {})
vim.keymap.set('n', '<leager>g', builtin.git_files, {})
vim.keymap.set('n', '<leader>f', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})


local actions = require('telescope.actions')

require('telescope').setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--follow",
      "--glob",
      "!.git/*"
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  },
})
