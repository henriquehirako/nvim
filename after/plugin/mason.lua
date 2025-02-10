require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ruby_lsp", "rubocop", "eslint", "helm_ls", "pyright", "gopls", "tailwindcss" },
})
