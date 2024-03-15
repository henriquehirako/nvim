require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ruby_ls", "tsserver", "helm_ls", "pyright" },
})
