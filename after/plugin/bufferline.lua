local bufferline = require('bufferline')
bufferline.setup {
  options = {
    style_preset = bufferline.style_preset.no_italic,
    indicator = {
      style = 'underline' -- 'icon' | 'underline' | 'none',
    },
  }
}
