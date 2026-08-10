return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    sections = {
      lualine_c = {
        {
          'filename',
          file_status = true,     -- readonly / modified indicators
          newfile_status = false, -- new file means no write since created
          path = 1,               -- relative path
        },
      },
    },
  },
}
