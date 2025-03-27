-- "Copilot"
-- let g:copilot_no_tab_map = v:true
-- let g:copilot_no_virtual_text = v:true
-- inoremap <silent><script><expr> <C-Space> copilot#Accept("\<CR>")
-- vim.cmd [[inoremap <silent><script><expr> <C-J> copilot#Next()]]
-- vim.cmd [[inoremap <silent><script><expr> <C-K> copilot#Previous()]]
-- vim.cmd [[nnoremap <silent><expr><C-@> ":Copilot panel<CR>"]]

-- copilot.lua
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require("copilot_cmp").setup()
