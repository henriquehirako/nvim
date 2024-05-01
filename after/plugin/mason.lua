require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ruby_lsp", "tsserver", "helm_ls", "pyright" },
})
