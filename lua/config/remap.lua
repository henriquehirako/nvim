vim.g.mapleader = ","
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader><leader>", vim.cmd.NvimTreeToggle)

-- Buffers Navigation
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<C-N>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<C-W>", ":bdelete<CR>", { silent = true })

-- REMAP REDO
vim.keymap.set("n", "<S-U>", "<C-R>")

-- Run commands on a new Tmux pannel
-- <leader>t: Run rails test current line
-- <leader>T: Run rails test current file
-- <leader>r: Run ruby %
-- <leader>R: Run rails runner %
vim.keymap.set("n", "<leader>t", ":execute 'Start bundle exec rails test -b '.expand('%:p').':'.line('.') <cr> <bar> :Tmux join-pane -h -t !<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>T", ":execute 'Start bundle exec rails test -b '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>r", ":execute 'Start ruby -rbyebug '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>R", ":execute 'Start bundle exec rails runner '.expand('%:p') <cr> <bar> :Tmux join-pane -h -t !<cr>", { silent = true, noremap = true })
