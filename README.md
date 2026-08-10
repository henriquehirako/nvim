# nvim

Personal Neovim configuration. Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim),
LSP servers by [mason.nvim](https://github.com/mason-org/mason.nvim) — both bootstrap themselves on
first launch.

## Requirements

* [Neovim v0.12+](https://github.com/neovim/neovim/wiki/Installing-Neovim) — required, not optional.
  The config uses `vim.lsp.config()`, `vim.diagnostic.jump()`, `vim.uv`, and the nvim-treesitter
  `main` branch API, none of which exist on older versions.
* `git` and a C compiler — lazy.nvim clones plugins; treesitter compiles parsers.
* [ripgrep](https://github.com/BurntSushi/ripgrep) — telescope's file finding and live grep.
* A [Nerd Font](https://www.nerdfonts.com/) — nvim-tree, bufferline, and lualine use glyph icons.

Optional, per language:

* **Ruby** — `ruby-lsp` and `rubocop` are expected on rbenv shims (`~/.rbenv/shims/`), not installed
  through Mason. ALE additionally shells out to `bundle exec` for `rubocop`, `reek`, and
  `rails_best_practices`.
* **JavaScript / TypeScript** — a global `eslint` (ALE is set to use the global executable) and
  `stylelint` for CSS/SCSS.
* **Other** — `yamllint`, `gofmt`, `pgformatter` cover the remaining ALE fixers and linters.

## Install

```bash
git clone git@github.com:henriquehirako/nvim.git ~/.config/nvim
```

Then start Neovim. lazy.nvim installs itself, syncs plugins to the versions pinned in
`lazy-lock.json`, and Mason installs the language servers. Treesitter parsers compile in the
background on first use.

Verify with `:checkhealth`, `:Lazy`, and `:Mason`.

## Layout

```
init.lua                 entry point; requires lua/config
lua/config/
  init.lua               load order: remap -> lazy -> set -> colors
  remap.lua              leader key and core keymaps
  lazy.lua               bootstrap + the full plugin list
  set.lua                vim options
  colors.lua             termguicolors detection
after/plugin/            per-plugin configuration, sourced after plugins load
```

Plugins are *declared* in `lua/config/lazy.lua` and *configured* in a matching
`after/plugin/<plugin>.lua` file.

## Keymaps

Leader is `,`.

| Key | Action |
| --- | --- |
| `<leader><leader>` | toggle file tree |
| `<C-p>` | find files (includes hidden, skips `.git`) |
| `<leader>g` | git files |
| `<leader>f` | live grep |
| `<leader>b` | buffers |
| `<leader>h` | help tags |
| `<S-Tab>` / `<C-n>` | previous / next buffer |
| `<C-w>` | close buffer |
| `<S-u>` | redo |
| `J` / `K` (visual) | move selection down / up |
| `<leader>t` / `<leader>T` | run Rails test at cursor / for the file |
| `<leader>r` | repeat last dispatch |

LSP mappings are buffer-local and attach with the server: `gd` definition, `gD` declaration,
`gi` implementation, `gr` references, `K` hover, `<space>rn` rename, `<space>ca` code action,
`<space>f` format, `[d` / `]d` previous / next diagnostic.

Completion is nvim-cmp with Copilot ranked above LSP. `<C-j>` / `<C-k>` cycle the menu, `<CR>`
confirms the selected entry, and `<Tab>` accepts the inline Copilot suggestion.

## License

MIT — see [LICENSE](LICENSE).
