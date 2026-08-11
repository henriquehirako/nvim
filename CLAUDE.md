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
2. `config.lazy` — bootstraps lazy.nvim into `stdpath('data')/lazy`, then hands off with `require('lazy').setup('plugins')`
3. `config.set` — vim options
4. `config.colors` — termguicolors detection

**The key structural convention:** each plugin gets **one file** under `lua/plugins/`, holding its spec *and* its configuration together. `lua/config/lazy.lua` names no plugins at all — lazy.nvim imports every module in that directory — so adding a plugin means adding a file there and nothing else. A file returns either a single spec table or a list of related specs (see `languages.lua`, `copilot.lua`).

Configuration goes in the spec's `opts`/`config`, except for options a plugin reads at load time, which belong in `init` (`ale.lua` sets every `g:ale_*` there for exactly this reason).

Plugins are lazy-loaded on `event`/`ft`/`cmd`/`keys`. This has a sharp edge worth knowing: anything loading on `BufReadPre` or `FileType` runs *after* the first buffer's `FileType` has already fired, so a handler it registers never sees that buffer. Both `lsp.lua` and `treesitter.lua` compensate — `lsp.lua` re-fires `FileType` for already-loaded buffers, `treesitter.lua` starts highlighting on the current buffer directly.

> Note: an earlier layout put specs in `lua/config/lazy.lua` and configuration in `after/plugin/<plugin>.lua`. That split is gone and `after/plugin/` is empty — ignore any lingering references to it.

## Subsystems worth knowing

**LSP (`lua/plugins/lsp.lua`)** — the densest file. Uses the modern `vim.lsp.config('<server>', {...})` API (0.11+), *not* `require('lspconfig').<server>.setup{}`. Servers are installed via `mason-lspconfig`'s `ensure_installed`, and `ts_ls` is in `automatic_enable.exclude` (see TypeScript below). Ruby servers deliberately bypass Mason and point at rbenv shims (`~/.rbenv/shims/ruby-lsp`, `~/.rbenv/shims/rubocop --lsp`).

Completion capabilities are set **once**, on the `'*'` config, and never per-server. This is load-bearing, not style: a plugin that registers its own server config typically guards with `if vim.lsp.config[name] == nil`, so creating that key early — which `vim.lsp.config('<server>', { capabilities = ... })` does — makes the plugin skip registering `cmd`/`filetypes`/`root_dir`. The server then gets enabled with no `cmd` and silently never attaches. That exact bug disabled TypeScript entirely for a while.

**TypeScript is served by `tsgo`, with no plugin in between.** TypeScript 7 is the Go port of the compiler and ships no `tsserver.js`, so every tsserver wrapper — `ts_ls`, `typescript-tools.nvim` — cannot drive a project's own TypeScript and silently falls back to a bundled 5.x, making editor diagnostics drift from `tsc`. The native binary speaks LSP over stdio instead. `lsp.lua` overrides only nvim-lspconfig's `tsgo` `cmd` (its `root_dir` carries the monorepo and Deno-detection logic worth keeping) to resolve the binary under either name it ships as: `tsgo` from `@typescript/native-preview`, or `tsc` from `typescript@7` itself. A `tsc` is accepted only after reporting major version >= 7, so a TypeScript 5 on `PATH` — which has no `--lsp` flag — is never picked up. Prefer the project-local `node_modules/.bin` copy over a global one.

Two `LspAttach` autocmds exist: one installs the custom current-line diagnostic renderer (virtual text is globally off; a `CursorHold` handler paints diagnostics for the cursor line into the `CurlineDiag` namespace), the other installs buffer-local keymaps, enables inlay hints where the server supports them, and nils out `semanticTokensProvider` so treesitter owns highlighting. `<space>ih` toggles inlay hints per-buffer, `<space>oi` runs `source.organizeImports`.

**Completion** — nvim-cmp with source priority `copilot` → `nvim_lsp`, falling back to `buffer`. `lua/plugins/nvim-cmp.lua` makes a single `cmp.setup` call (it was previously split across two that relied on cmp merging them). `<CR>` only confirms when an entry is actively selected. Copilot inline suggestions accept on `<Tab>` (copilot.lua), which is why `<Tab>` is *not* bound in cmp. Snippet expansion is not configured and does not need to be — nvim-cmp falls back to Neovim's built-in `vim.snippet`.

`lua/plugins/copilot.lua` carries a runtime monkey-patch: copilot-cmp is archived and calls deprecated `client.is_stopped()` with dot syntax, so `copilot_cmp_source.is_available` is overridden. If copilot-cmp is ever replaced (e.g. by blink.cmp or copilot.lua's own cmp integration), delete that patch with it.

**Linting is dual-stack.** ALE (`lua/plugins/ale.lua`, `g:ale_*` options set in `init` so they land before ALE loads) runs on save/enter only — never on text change — and handles rubocop/eslint/prettier/stylelint/yamllint. LSP diagnostics run in parallel. Ruby linters shell out through `bundle`. Expect duplicate rubocop diagnostics (ALE + `rubocop --lsp`) if you touch either side.

`ale_linters_explicit = 1` means a filetype with no entry in `g:ale_linters` gets **no** linters at all. The react filetypes are distinct from their base language here — `typescriptreact` and `javascriptreact` need their own entries or `.tsx`/`.jsx` files go unlinted. `*_use_global` is off so eslint and prettier resolve from the project's `node_modules/.bin` first; forcing it on breaks linting entirely on machines where those tools aren't installed globally.

Caveat for TypeScript 7 projects: `typescript-eslint` still declares a `typescript` peer range of `<6.1.0`, so it won't install alongside `typescript@7`. Plain eslint works; TS-aware eslint rules are unavailable until upstream catches up.

**Treesitter** is on the `main` branch API (0.12+): `setup{}` takes only `install_dir`, parsers come from `ts.install{...}`, and highlighting is turned on by an explicit `FileType` autocmd calling `vim.treesitter.start()`. **Parser names are not filetype names** — a `.tsx` buffer has filetype `typescriptreact` but is parsed by `tsx`. The autocmd resolves filetype → parser through `vim.treesitter.language.get_lang()` rather than matching the parser list against filetypes, because `get_lang()` returns the filetype unchanged when unmapped, which silently left every mismatched filetype unhighlighted. Filetypes Neovim doesn't already map live in the `filetype_parsers` table; add a language to `parsers`, and only add a `filetype_parsers` entry if its filetype differs from the parser name.

**Test running (`lua/plugins/dispatch.lua`)** — `<leader>t` / `<leader>T` / `<leader>r` run Rails tests through vim-dispatch, opening a vertical split and then `Tmux join-pane` to pull it into a tmux pane when tmux is present. Hardcoded to `bundle exec rails test`.

**Focus mode** — no-neck-pain is declared in `lua/plugins/editing.lua` gated on `cmd = 'NoNeckPain'`, with no `opts`/`config` at all: it runs on stock defaults. Its old configuration and its `<Leader>g` mapping (still commented out in `lua/config/remap.lua`) did not survive the move to `lua/plugins/`.

## Conventions and gotchas

- `lua/config/set.lua` is almost entirely `vim.cmd [[set ...]]` rather than `vim.opt`. It works, but is the obvious modernization target.
- Leader is `,`. `<leader>g` is telescope `git_files`; the old no-neck-pain binding on the same key is commented out in `lua/config/remap.lua`, so there is no longer a conflict.
- Swap/backup/undo directories (`.tmp/`, `.backup/`, `.undo/`) live **inside this repo** and are gitignored. They contain hundreds of files with encoded absolute paths from the user's real work — ignore them entirely when searching; never read or commit them.
- `lua/config/colors.lua` only handles `termguicolors` detection. The colorscheme itself is set in `lua/plugins/github-theme.lua`'s `config` (`github_dark_dimmed`, transparent background).
- `todo.md` is a link dump of LSP references, not a task list.

## Other agent configs

An OpenAI Codex install exists at `~/.codex/`, but it holds nothing importable: `AGENTS.md` is empty, `skills/` is empty, and both MCP servers in `config.toml` are binaries inside `/Applications/ChatGPT.app` that only run under Codex. The rest is model choice, desktop UI prefs, and OpenAI marketplace plugins. Checked 2026-08-10 — no need to re-scan unless that config changes.
