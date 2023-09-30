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

-- Toggle distraction free mode
-- vim.cmd [[nnoremap <Leader>g :NoNeckPain <CR>]]
