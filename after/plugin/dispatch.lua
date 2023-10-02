-- Run commands on a new pannel

-- <leader>t: Run rails test current line
-- <leader>T: Run rails test current file
-- <leader>r: repeat last dispatch command

-- On a vsplit terminal panel
-- vim.keymap.set("n", "<leader>t", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p').':'.line('.') <CR><BAR> :Dispatch <CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>T", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p') <CR><BAR> :Dispatch <CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>r", ":Dispatch <CR>", { silent = true, noremap = true })

-- Disable dispatch on tmux (needed if you want to use terminal split but inside tmux)
-- vim.cmd [[let g:dispatch_no_tmux_make = 1]]
-- vim.cmd [[let g:dispatch_no_tmux_start = 1]]

-- On a vsplit TMUX panel
-- vim.keymap.set("n", "<leader>t", ":execute 'Focus :Start bundle exec rails test -b '.expand('%:p').':'.line('.') <CR><BAR> :Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>T", ":execute 'Focus :Start bundle exec rails test -b '.expand('%:p') <CR><BAR> :Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
-- vim.keymap.set("n", "<leader>r", ":Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })

-- Combined - On a vsplit terminal but opens in TMUX if tmux is running
vim.keymap.set("n", "<leader>t", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p').':'.line('.') <CR><BAR> :Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>T", ":execute 'Focus :vert belowright Start bundle exec rails test -b '.expand('%:p') <CR><BAR> :Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>r", ":Dispatch <CR><BAR> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
