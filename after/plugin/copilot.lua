-- "Copilot"
-- let g:copilot_no_tab_map = v:true
-- let g:copilot_no_virtual_text = v:true
-- inoremap <silent><script><expr> <C-Space> copilot#Accept("\<CR>")
-- vim.cmd [[inoremap <silent><script><expr> <C-J> copilot#Next()]]
-- vim.cmd [[inoremap <silent><script><expr> <C-K> copilot#Previous()]]
-- vim.cmd [[nnoremap <silent><expr><C-@> ":Copilot panel<CR>"]]

-- copilot.lua
require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<Tab>",
    },
  },
  -- nes = { enabled = true },
  panel = { enabled = true },
})

-- copilot-cmp is archived and still calls the deprecated `client.is_stopped()`
-- (dot call) on every completion evaluation, which spams the deprecation
-- warning on nvim 0.11+. Override `is_available` to use the method form.
-- Instances share this table via `__index`, so patching it here covers them all.
local copilot_cmp_source = require("copilot_cmp.source")

copilot_cmp_source.is_available = function(self)
  local client = self.client
  if not client or client:is_stopped() or client.name ~= "copilot" then
    return false
  end

  return next(vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    id = client.id,
  })) ~= nil
end

require("copilot_cmp").setup()
--

