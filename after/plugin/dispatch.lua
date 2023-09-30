-- Run commands on a new pannel

-- <leader>t: Run rails test current line
-- <leader>T: Run rails test current file
-- <leader>r: repeat last dispatch command
vim.keymap.set("n", "<leader>t", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p').':'.line('.') <cr> <bar> :Dispatch <cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>T", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p') <cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>r", ":Dispatch <CR>", { silent = true, noremap = true })
vim.cmd [[let g:dispatch_no_tmux_make = 1]]
vim.cmd [[let g:dispatch_no_tmux_start = 1]]

-- TMUX ALTERNATIVES
-- vim.keymap.set("n", "<leader>t", ":execute 'Start bundle exec rails test -b '.expand('%:p').':'.line('.') <cr> <bar> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>T", ":execute 'Start bundle exec rails test -b '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>r", ":execute 'Start ruby -rbyebug '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>R", ":execute 'Start bundle exec rails runner '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
