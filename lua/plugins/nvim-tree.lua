return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeFocus' },
  keys = {
    { '<leader><leader>', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
  },
  -- init runs at startup even though the plugin itself is lazy: netrw has to be
  -- disabled before Neovim loads it, which happens long before the first toggle.
  init = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    sort_by = 'case_sensitive',
    view = {
      width = 30,
      adaptive_size = true,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    update_focused_file = {
      enable = true,
      update_root = false,
      ignore_list = {},
    },
  },
}
