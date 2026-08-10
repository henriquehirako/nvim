# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration, cloned to `~/.config/nvim`. There is no build, no test suite, and no package manager beyond lazy.nvim. "Running the code" means starting Neovim. Currently running against **Neovim 0.12.x** (README still claims 0.8+, which is stale — several APIs used here require 0.11+/0.12).

## Verifying changes

```bash
# Fastest smoke test: does the config load without errors?
nvim --headless +qa

# Sync/install plugins per lazy-lock.json, then quit
nvim --headless "+Lazy! sync" +qa

# Health check for a specific subsystem
nvim --headless "+checkhealth lazy" +qa
nvim --headless "+checkhealth vim.lsp" +qa
```

Interactive checks worth doing after touching plugin config: `:Lazy`, `:Mason`, `:LspInfo`, `:checkhealth`, `:InspectTree` (replaces the removed treesitter playground).

`lazy-lock.json` is committed — plugin version bumps show up as changes there and should be committed deliberately, not as drive-by noise.

No Lua formatter/linter is installed (no stylua, luacheck, or selene). Match surrounding style by hand: 2-space indent, single quotes in newer files, double quotes in older ones.

## Load architecture

`init.lua` does one thing: `require("config")`. That resolves to `lua/config/init.lua`, which requires in a deliberate order:

1. `config.remap` — leader key (`,`) must be set before plugins register mappings
2. `config.lazy` — bootstraps lazy.nvim into `stdpath('data')/lazy` and declares the **entire plugin list**
3. `config.set` — vim options
4. `config.colors` — termguicolors detection

Then Neovim's normal runtime rule takes over: every file in `after/plugin/*.lua` is sourced automatically after plugins load.

**The key structural convention:** `lua/config/lazy.lua` only *declares* plugins (specs, deps, `ft` gating, `build`). Nearly all plugin *configuration* lives in a matching `after/plugin/<plugin>.lua` file, not in a lazy `opts`/`config` block. When adding a plugin, follow this split — declare it in `lazy.lua`, configure it in a new `after/plugin/` file. Files in `after/plugin/` load in alphabetical order and cannot depend on each other's ordering, so they must be self-contained.

Consequence: plugins here are effectively eagerly loaded. Only the language plugins use `ft =` gating. Don't assume lazy-loading semantics.

## Subsystems worth knowing

**LSP (`after/plugin/lsp-config.lua`)** — the densest file. Uses the modern `vim.lsp.config('<server>', {...})` API (0.11+), *not* `require('lspconfig').<server>.setup{}`. Servers are installed via `mason-lspconfig`'s `ensure_installed`, but `lua_ls` and `ts_ls` are in `automatic_enable.exclude` because they're driven elsewhere (`lua_ls` by the explicit `vim.lsp.config` block, TypeScript by `typescript-tools.nvim`). Ruby servers deliberately bypass Mason and point at rbenv shims (`~/.rbenv/shims/ruby-lsp`, `~/.rbenv/shims/rubocop --lsp`).

Two `LspAttach` autocmds exist: one installs the custom current-line diagnostic renderer (virtual text is globally off; a `CursorHold` handler paints diagnostics for the cursor line into the `CurlineDiag` namespace), the other installs buffer-local keymaps and nils out `semanticTokensProvider` so treesitter owns highlighting.

**Completion** — nvim-cmp with source priority `copilot` → `nvim_lsp`, falling back to `buffer`. `after/plugin/nvim-cmp.lua` calls `cmp.setup` twice (mappings/sources first, then a separate `formatting` block via lspkind); this is intentional-by-accretion, and the second call merges rather than replaces. `<CR>` only confirms when an entry is actively selected. Copilot inline suggestions accept on `<Tab>` (copilot.lua), which is why `<Tab>` is *not* bound in cmp.

`after/plugin/copilot.lua` carries a runtime monkey-patch: copilot-cmp is archived and calls deprecated `client.is_stopped()` with dot syntax, so `copilot_cmp_source.is_available` is overridden. If copilot-cmp is ever replaced (e.g. by blink.cmp or copilot.lua's own cmp integration), delete that patch with it.

**Linting is dual-stack.** ALE (`after/plugin/ale.lua`, all vimscript via `vim.cmd`) runs on save/enter only — never on text change — and handles rubocop/eslint/stylelint/yamllint. LSP diagnostics run in parallel. Ruby linters shell out through `bundle`. Expect duplicate rubocop diagnostics (ALE + `rubocop --lsp`) if you touch either side.

**Treesitter** is on the `main` branch API (0.12+): `setup{}` takes only `install_dir`, parsers come from `ts.install{...}`, and highlighting is turned on by an explicit `FileType` autocmd calling `vim.treesitter.start()`. The parser list appears **twice** in `after/plugin/treesitter.lua` — in `install` and in the autocmd `pattern` — keep them in sync when adding a language.

**Test running (`after/plugin/dispatch.lua`)** — `<leader>t` / `<leader>T` / `<leader>r` run Rails tests through vim-dispatch, opening a vertical split and then `Tmux join-pane` to pull it into a tmux pane when tmux is present. Hardcoded to `bundle exec rails test`.

**Focus mode** — note that `after/plugin/no-neck-pain.lua` builds an `options` table but the final `nnp.setup(options)` call is **commented out**, so none of it applies; the `NoNeckPain.*` globals are also referenced before assignment. Treat that file as dormant.

## Conventions and gotchas

- `lua/config/set.lua` is almost entirely `vim.cmd [[set ...]]` rather than `vim.opt`. It works, but is the obvious modernization target.
- Leader is `,`. Both `<leader>g` (telescope git_files) and `<Leader>g` (no-neck-pain toggle) claim the same key — telescope wins in practice since no-neck-pain's setup is disabled.
- Swap/backup/undo directories (`.tmp/`, `.backup/`, `.undo/`) live **inside this repo** and are gitignored. They contain hundreds of files with encoded absolute paths from the user's real work — ignore them entirely when searching; never read or commit them.
- `after/plugin/colors.lua` is entirely commented out; the active colorscheme is set at the bottom of `after/plugin/github-theme.lua` (`github_dark_dimmed`, transparent background).
- `todo.md` is a link dump of LSP references, not a task list.

## Other agent configs

An OpenAI Codex install exists at `~/.codex/`, but it holds nothing importable: `AGENTS.md` is empty, `skills/` is empty, and both MCP servers in `config.toml` are binaries inside `/Applications/ChatGPT.app` that only run under Codex. The rest is model choice, desktop UI prefs, and OpenAI marketplace plugins. Checked 2026-08-10 — no need to re-scan unless that config changes.
