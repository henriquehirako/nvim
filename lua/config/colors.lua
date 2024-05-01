vim.cmd([[
  if (empty($TMUX) && $TERM_PROGRAM == 'Apple_Terminal')
    set notermguicolors
  else
    set termguicolors
  endif
]])

-- vim.cmd([[ set notermguicolors]])

-- vim.g.base16_colorspace = 256
