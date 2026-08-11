return {
  'dense-analysis/ale',
  event = { 'BufReadPost', 'BufNewFile' },
  -- ALE reads every g:ale_* option when it loads, so these must be set before
  -- that happens -- `init` runs at startup, `config` would run too late.
  init = function()
    local g = vim.g

    g.ale_linter_aliases = { smarty = { 'yaml' } }

    -- The react filetypes are distinct from their base language as far as ALE is
    -- concerned: a .tsx buffer is `typescriptreact`, and without its own entry
    -- here it gets no linters at all (see ale_linters_explicit below).
    g.ale_fixers = {
      javascript = { 'eslint', 'prettier' },
      javascriptreact = { 'eslint', 'prettier' },
      typescript = { 'eslint', 'prettier' },
      typescriptreact = { 'eslint', 'prettier' },
      json = { 'prettier' },
      scss = { 'stylelint' },
      css = { 'stylelint' },
      go = { 'gofmt' },
      solidity = { 'solium' },
      ruby = { 'rubocop' },
      sql = { 'pgformatter' },
    }

    g.ale_linters = {
      javascript = { 'eslint' },
      javascriptreact = { 'eslint' },
      typescript = { 'eslint' },
      typescriptreact = { 'eslint' },
      scss = { 'stylelint' },
      css = { 'stylelint' },
      go = { 'gofmt' },
      solidity = { 'solium' },
      php = { 'php' },
      ruby = { 'rails_best_practices', 'rubocop', 'reek' },
      yaml = { 'yamllint' },
      yml = { 'yamllint' },
    }

    -- Only run the linters listed above. Without this, ALE runs every linter it
    -- can find for filetypes missing from the dict -- including language servers
    -- it starts itself. For lua that meant ALE spawning its own
    -- lua-language-server (via `/bin/zsh -c`, with no settings), which shadowed
    -- the lua_ls configured in lsp.lua and reported `Undefined global 'vim'`
    -- throughout this config.
    g.ale_linters_explicit = 1

    g.ale_completion_enabled = 0
    g.ale_emit_conflict_warnings = 0
    g.ale_use_neovim_diagnostics_api = 1

    -- Resolve eslint and prettier from the project's node_modules first, falling
    -- back to PATH. This was previously forced to the global executable, and
    -- since neither tool is installed globally here, JS/TS linting never ran at
    -- all -- ALE silently found no executable and reported nothing.
    g.ale_javascript_eslint_use_global = 0
    g.ale_javascript_prettier_use_global = 0

    -- Ruby tooling runs through bundler so it matches the project's Gemfile.
    g.ale_ruby_rails_best_practices_executable = 'bundle'
    g.ale_ruby_reek_executable = 'bundle'
    g.ale_ruby_rubocop_executable = 'bundle'

    -- Lint on save and on open only -- never while typing.
    --
    -- fix_on_save stays globally off and is opted into per filetype below:
    -- ale#Var() reads b:ale_fix_on_save before falling back to this. Turning it
    -- on globally would apply every configured fixer on every write, so saving
    -- a Ruby file would silently run `rubocop --auto-correct` over it.
    g.ale_fix_on_save = 0
    g.ale_lint_on_text_changed = 'never'
    g.ale_lint_on_insert_leave = 0
    g.ale_lint_on_enter = 1
    g.ale_lint_on_save = 1
    g.ale_cache_executable_check_failures = 1

    g.ale_echo_msg_format = '[%linter%] %code% - %s [%severity%]'
    g.ale_sign_error = '✘'
    g.ale_sign_warning = '⚠'

    -- Run the fixers above on save, for the web filetypes only -- prettier for
    -- js/ts/json, stylelint for css/scss. Everything else keeps save read-only.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('AleFixOnSave', { clear = true }),
      pattern = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'json',
        'css',
        'scss',
      },
      callback = function(ev)
        vim.b[ev.buf].ale_fix_on_save = 1
      end,
    })
  end,
}
