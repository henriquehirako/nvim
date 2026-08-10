return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  -- opts as a function: style_preset is a value off the module itself, so it
  -- cannot be written as a plain table literal.
  opts = function()
    local bufferline = require('bufferline')

    return {
      options = {
        style_preset = bufferline.style_preset.no_italic,
        indicator = {
          style = 'underline', -- 'icon' | 'underline' | 'none'
        },
      },
    }
  end,
}
