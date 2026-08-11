return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- default_capabilities() below needs this loaded
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    -- Capabilities go on the '*' config, which Neovim merges into every server.
    -- Setting them per-server means creating that server's vim.lsp.config entry,
    -- and a plugin that registers its own config typically does so only while
    -- the entry is still nil -- creating it early silently leaves the server
    -- with no `cmd`, enabled but unable to start.
    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    })

    -- TypeScript 7 is the Go port of the compiler: there is no tsserver.js any
    -- more, so the tsserver wrappers (ts_ls, typescript-tools.nvim) cannot drive
    -- a project's own TypeScript -- they fall back to a bundled 5.x, which makes
    -- editor diagnostics drift from what `tsc` reports. The native binary speaks
    -- LSP directly over stdio instead.
    --
    -- It ships under two names: `tsgo` from @typescript/native-preview, and
    -- `tsc` from typescript@7 itself. nvim-lspconfig's tsgo config only looks for
    -- `tsgo`, so resolve the binary here. A `tsc` is accepted only once it has
    -- reported major version >= 7, so a leftover TypeScript 5 on PATH -- which
    -- has no --lsp flag -- is never picked up.
    local speaks_lsp = {}

    local function is_typescript_7(exe)
      if speaks_lsp[exe] == nil then
        local version = vim.fn.system({ exe, '--version' })
        local major = tonumber(version:match('Version (%d+)') or '')
        speaks_lsp[exe] = vim.v.shell_error == 0 and major ~= nil and major >= 7
      end
      return speaks_lsp[exe]
    end

    local function resolve_tsgo(root_dir)
      for _, name in ipairs({ 'tsgo', 'tsc' }) do
        local candidates = {}
        if root_dir then
          candidates[#candidates + 1] = vim.fs.joinpath(root_dir, 'node_modules', '.bin', name)
        end
        candidates[#candidates + 1] = name

        for _, exe in ipairs(candidates) do
          -- `tsgo` is always the native server; `tsc` has to earn it.
          if vim.fn.executable(exe) == 1 and (name == 'tsgo' or is_typescript_7(exe)) then
            return exe
          end
        end
      end
    end

    -- Only the cmd is overridden -- the upstream config's root_dir carries the
    -- monorepo and Deno-detection logic, and its settings enable inlay hints.
    vim.lsp.config('tsgo', {
      cmd = function(dispatchers, config)
        local exe = resolve_tsgo((config or {}).root_dir)
        if not exe then
          vim.notify(
            '[lsp] no TypeScript 7 binary found (tsgo, or tsc >= 7)',
            vim.log.levels.WARN
          )
          exe = 'tsgo' -- fail loudly in :LspLog rather than silently not attaching
        end
        return vim.lsp.rpc.start({ exe, '--lsp', '--stdio' }, dispatchers)
      end,
    })
    vim.lsp.enable('tsgo')

    vim.lsp.config('ruby_lsp', {
      -- cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv('GLOBAL_GEMFILE') },
      cmd = { vim.fn.expand('~/.rbenv/shims/ruby-lsp') },
    })

    vim.lsp.config('rubocop', {
      -- cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv('GLOBAL_GEMFILE') },
      cmd = { vim.fn.expand('~/.rbenv/shims/rubocop'), '--lsp' },
    })

    vim.lsp.config('lua_ls', {
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
      },
      -- Excluded servers are never enabled, so anything listed here must either
      -- be started by another plugin or not wanted at all. ts_ls wraps
      -- tsserver.js, which TypeScript 7 no longer ships -- tsgo above serves
      -- TypeScript instead, so ts_ls stays excluded in case an older Mason
      -- install of it is still on disk. lua_ls is NOT excluded, otherwise the
      -- vim.lsp.config block above never takes effect and nothing serves lua
      -- buffers.
      automatic_enable = {
        exclude = {
          'ts_ls',
        },
      },
    })

    -- vim.lsp.enable() (called by automatic_enable above) attaches servers by
    -- hooking FileType. The buffer that triggered this plugin load has often
    -- already fired FileType by the time we get here, so it would never get a
    -- server. Re-fire the event for every buffer that is already loaded.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
        vim.api.nvim_exec_autocmds('FileType', { buffer = buf, modeline = false })
      end
    end

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

        -- Inferred parameter/return/variable types shown inline. tsgo's upstream
        -- config already narrows which hints it emits; <space>ih toggles them
        -- per-buffer when they get in the way.
        if client and client:supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end

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
        vim.keymap.set('n', '<space>ih', function()
          vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
            { bufnr = ev.buf }
          )
        end, opts)
        -- Drops unused imports and sorts the rest -- the one tsserver-era action
        -- worth a dedicated key.
        vim.keymap.set('n', '<space>oi', function()
          vim.lsp.buf.code_action({
            context = { only = { 'source.organizeImports' }, diagnostics = {} },
            apply = true,
          })
        end, opts)
        vim.keymap.set('n', '<space>f', function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end,
    })
  end,
}
