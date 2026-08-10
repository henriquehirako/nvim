-- Quality-of-life plugins with no configuration of their own.
return {
  'tpope/vim-sensible',   -- nice defaults to always have
  'tpope/vim-repeat',     -- improves `.` repeating
  'tpope/vim-surround',   -- [c]hange [s]urround
  'tpope/vim-obsession',  -- saves session before exit

  { 'tpope/vim-commentary', keys = { { 'gc', mode = { 'n', 'x', 'o' } }, 'gcc' } },
  { 'tpope/vim-endwise', ft = { 'ruby', 'lua', 'vim', 'sh' } }, -- auto `end`
  { 'tpope/vim-fugitive', cmd = { 'G', 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gblame' } },

  -- TMUX integration
  'christoomey/vim-tmux-navigator', -- C-hjkl moves between tmux panes
  'tpope/vim-tbone',                -- call tmux commands from vim

  -- Focus mode. Note: this plugin is currently unconfigured -- the setup() call
  -- that used to live in after/plugin/no-neck-pain.lua was commented out, so
  -- none of its options or mappings apply.
  { 'shortcuts/no-neck-pain.nvim', version = '*', cmd = 'NoNeckPain' },
}
