-- Set colorscheme
vim.cmd [[set termguicolors]]
vim.cmd [[let ayucolor="dark"]]
vim.cmd [[colorscheme ayu]]
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
