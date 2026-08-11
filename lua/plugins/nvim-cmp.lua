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
    'zbirenbaum/copilot.lua', -- the <Tab> mapping below requires copilot.suggestion
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

        -- One mapping arbitrates between Copilot's ghost text and this menu, in
        -- that order (copilot.lua's own accept keymap is disabled for this
        -- reason). `select = true` confirms the top entry without selecting it
        -- first -- the whole point of <Tab> -- whereas <CR> below stays strict.
        ['<Tab>'] = cmp.mapping(function(fallback)
          local copilot = require('copilot.suggestion')
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          elseif vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

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

    -- copilot.lua's `hide_during_completion` only fires while the *native*
    -- popup menu is up (`pumvisible()`), but cmp's default entries view draws a
    -- floating window, so pumvisible() is always 0 and the ghost text ends up
    -- sitting on top of the menu. copilot.lua checks this buffer flag too, so
    -- drive it from cmp's own events: exactly one of the two is visible at any
    -- time, which is what makes the <Tab> mapping above unambiguous.
    cmp.event:on('menu_opened', function() vim.b.copilot_suggestion_hidden = true end)
    cmp.event:on('menu_closed', function() vim.b.copilot_suggestion_hidden = false end)
  end,
}
