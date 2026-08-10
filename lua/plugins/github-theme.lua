return {
  'projekt0n/github-nvim-theme',
  lazy = false,    -- a colorscheme has to be available immediately
  priority = 1000, -- and before anything that reads highlight groups
  opts = {
    options = {
      compile_path = vim.fn.stdpath('cache') .. '/github-theme',
      compile_file_suffix = '_compiled',
      hide_end_of_buffer = true, -- hide the trailing '~' column
      hide_nc_statusline = true, -- no underline on inactive statuslines
      transparent = true,        -- do not set a background
      terminal_colors = true,    -- set vim.g.terminal_color_* for :terminal
      dim_inactive = false,
      module_default = true,
      styles = {
        comments = 'NONE',
        functions = 'NONE',
        keywords = 'NONE',
        variables = 'NONE',
        conditionals = 'NONE',
        constants = 'NONE',
        numbers = 'NONE',
        operators = 'NONE',
        strings = 'NONE',
        types = 'NONE',
      },
      inverse = {
        match_paren = false,
        visual = false,
        search = false,
      },
      darken = {
        floats = true,
        sidebars = {
          enable = false,
          list = {},
        },
      },
      modules = {},
    },
    palettes = {},
    specs = {},
    groups = {
      all = {
        CursorLine = { bg = 'none' },
      },
    },
  },
  config = function(_, opts)
    require('github-theme').setup(opts)
    vim.cmd.colorscheme('github_dark_dimmed')
  end,
}
