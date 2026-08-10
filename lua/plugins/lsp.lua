return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- default_capabilities() below needs this loaded
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config('typescript-tools', {
      capabilities = capabilities,
    })

    vim.lsp.config('ruby_lsp', {
      capabilities = capabilities,
      -- cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv('GLOBAL_GEMFILE') },
      cmd = { vim.fn.expand('~/.rbenv/shims/ruby-lsp') },
    })

    vim.lsp.config('rubocop', {
      capabilities = capabilities,
      -- cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv('GLOBAL_GEMFILE') },
      cmd = { vim.fn.expand('~/.rbenv/shims/rubocop'), '--lsp' },
    })

    vim.lsp.config('gopls', { capabilities = capabilities })

    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            -- Which Lua version -- LuaJIT in Neovim's case
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Stop the server flagging `vim` as an undefined global
            globals = { 'vim' },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    })

    -- mason.nvim is set up by its own spec above (opts = {}), which lazy.nvim
    -- runs before this config -- mason_lspconfig requires it already set up.
    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'ruby_lsp',
        'rubocop',
        -- 'eslint',
        'helm_ls',
        'pyright',
        'gopls',
        'tailwindcss',
        'ts_ls',
      },
      -- Excluded servers are never enabled, so anything listed here must either
      -- be started by another plugin or not wanted at all. ts_ls is handled by
      -- typescript-tools.nvim; lua_ls is NOT excluded, otherwise the
      -- vim.lsp.config block above never takes effect and nothing serves lua
      -- buffers.
      automatic_enable = {
        exclude = {
          'ts_ls',
        },
      },
    })

    -- Diagnostics render on the current line only, via the CursorHold handler
    -- below, so the global virtual text is off.
    vim.diagnostic.config({
      virtual_text = false,
    })

    local ns = vim.api.nvim_create_namespace('CurlineDiag')
    vim.opt.updatetime = 100

    -- A single augroup with clear = true: without it this nested CursorHold
    -- autocmd was installed once per attached client (rubocop and copilot both
    -- attach to a ruby buffer) and again on every re-source, so the same line
    -- was cleared and repainted N times per idle tick.
    local curline_group = vim.api.nvim_create_augroup('CurlineDiag', { clear = true })

    vim.api.nvim_create_autocmd('LspAttach', {
      group = curline_group,
      callback = function(args)
        vim.api.nvim_clear_autocmds({ group = curline_group, event = 'CursorHold', buffer = args.buf })
        vim.api.nvim_create_autocmd('CursorHold', {
          group = curline_group,
          buffer = args.buf,
          callback = function()
            pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
            local hi = { 'Error', 'Warn', 'Info', 'Hint' }
            local curline = vim.api.nvim_win_get_cursor(0)[1]
            local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline - 1 })
            local virt_texts = { { (' '):rep(4) } }
            for _, diag in ipairs(diagnostics) do
              virt_texts[#virt_texts + 1] = { diag.message, 'Diagnostic' .. hi[diag.severity] }
            end
            vim.api.nvim_buf_set_extmark(args.buf, ns, curline - 1, 0, {
              virt_text = virt_texts,
              hl_mode = 'combine',
            })
          end,
        })
      end,
    })

    -- Global mappings. See `:help vim.diagnostic.*`
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Buffer-local mappings, installed when a server attaches.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
      callback = function(ev)
        -- Let treesitter own highlighting
        local client = vim.lsp.get_clients({ id = ev.data.client_id })[1]
        if client then client.server_capabilities.semanticTokensProvider = nil end

        -- Completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, opts) -- overrides tagfunc
        vim.keymap.set('n', 'K', function()
          vim.lsp.buf.hover {
            border = 'rounded',
            max_height = 20,
            max_width = 130,
            close_events = { 'CursorMoved', 'BufLeave', 'WinLeave', 'LSPDetach' },
          }
        end, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })
  end,
}
