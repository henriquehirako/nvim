-- Run Rails tests in a split. Opens a vertical terminal split, then pulls it
-- into a tmux pane when running under tmux.
local function rails_test(target)
  return function()
    local file = vim.fn.expand('%:p')
    local spec = target == 'line' and (file .. ':' .. vim.fn.line('.')) or file
    vim.cmd('Focus :vert belowright Start bundle exec rails test -b ' .. spec)
    vim.cmd('Dispatch')
    pcall(vim.cmd, 'Tmux join-pane -h -t !')
  end
end

return {
  'tpope/vim-dispatch',
  dependencies = { 'tpope/vim-tbone' }, -- provides :Tmux
  cmd = { 'Dispatch', 'Focus', 'Start', 'Make' },
  keys = {
    { '<leader>t', rails_test('line'), desc = 'Rails test (current line)' },
    { '<leader>T', rails_test('file'), desc = 'Rails test (current file)' },
    {
      '<leader>r',
      function()
        vim.cmd('Dispatch')
        pcall(vim.cmd, 'Tmux join-pane -h -t !')
      end,
      desc = 'Repeat last dispatch',
    },
  },
}
