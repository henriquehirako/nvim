return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'onsails/lspkind.nvim',
    'zbirenbaum/copilot-cmp', -- must configure first; registers the `copilot` source
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')

    -- cmp-nvim-lsp registers its source from its own after/plugin file, which
    -- does not run reliably once it is a lazy-loaded dependency rather than a
    -- startup plugin. Register it here so the `nvim_lsp` source always exists.
    require('cmp_nvim_lsp').setup()

    lspkind.init({
      symbol_map = {
        Copilot = '',
      },
    })

    vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })

    -- Previously split across two cmp.setup() calls -- the second passed only
    -- `formatting` and relied on cmp merging it into the first.
    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        -- <Tab> is deliberately unbound here: copilot.lua owns it for accepting
        -- inline suggestions.
        ['<CR>'] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
      }),

      sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
      }, {
        { name = 'buffer' },
      }),

      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = {
            menu = 100, -- leading text (labelDetails)
            abbr = 100, -- actual suggestion item
          },
          ellipsis_char = '...',
          show_labelDetails = true,
          before = function(_, vim_item)
            vim_item.menu = ''
            vim_item.kind = ''
            return vim_item
          end,
        }),
      },
    })
  end,
}
