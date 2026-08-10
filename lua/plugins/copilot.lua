return {
  {
    'zbirenbaum/copilot.lua',
    dependencies = { 'copilotlsp-nvim/copilot-lsp' },
    event = 'InsertEnter',
    cmd = 'Copilot',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
        },
      },
      -- nes = { enabled = true }, -- next-edit suggestions
      panel = { enabled = true },
    },
  },

  {
    -- Registers the `copilot` cmp source, so it must be configured before
    -- nvim-cmp's own config runs -- nvim-cmp lists this as a dependency.
    'zbirenbaum/copilot-cmp',
    dependencies = { 'zbirenbaum/copilot.lua' },
    -- Reached through nvim-cmp's dependencies. Without this it is a top-level
    -- spec with no lazy handler, which lazy.nvim treats as eager -- and its
    -- config requires cmp, dragging the whole completion stack into startup.
    lazy = true,
    config = function()
      -- copilot-cmp is archived and still calls the deprecated
      -- `client.is_stopped()` (dot call) on every completion evaluation, which
      -- spams the deprecation warning on nvim 0.11+. Override `is_available` to
      -- use the method form. Instances share this table via `__index`, so
      -- patching it here covers them all.
      local copilot_cmp_source = require('copilot_cmp.source')

      copilot_cmp_source.is_available = function(self)
        local client = self.client
        if not client or client:is_stopped() or client.name ~= 'copilot' then
          return false
        end

        return next(vim.lsp.get_clients({
          bufnr = vim.api.nvim_get_current_buf(),
          id = client.id,
        })) ~= nil
      end

      require('copilot_cmp').setup()
    end,
  },

  -- Alternatives previously kept commented in lua/config/lazy.lua:
  --
  -- 'github/copilot.vim'      -- superseded by copilot.lua above
  -- 'Exafunction/codeium.vim'
  -- {
  --   'CopilotC-Nvim/CopilotChat.nvim',
  --   dependencies = { { 'nvim-lua/plenary.nvim', branch = 'master' } },
  --   build = 'make tiktoken',
  --   opts = {},
  -- },
}
