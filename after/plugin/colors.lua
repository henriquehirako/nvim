-- Set colorscheme
vim.cmd [[set termguicolors]]

-- AYU settings
-- vim.cmd [[let ayucolor="dark"]]
-- vim.cmd [[colorscheme ayu]]

-- Moonfly settings
-- vim.cmd [[colorscheme moonfly]]

-- Github theme settings
-- vim.cmd [[colorscheme github_dark_high_contrast]]
-- vim.cmd [[colorscheme github_dark_tritanopia]]
-- setup in after/github-theme.lua

-- Transparent BG when supported
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
