-- Set colorscheme
vim.cmd [[set termguicolors]]

-- AYU settings
-- vim.cmd [[let ayucolor="dark"]]
-- vim.cmd [[colorscheme ayu]]

-- Moonfly settings
vim.cmd [[colorscheme moonfly]]

-- Transparent BG when supported
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
