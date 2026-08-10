return {
  'ecthelionvi/NeoColumn.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  opts = {
    always_on = true,
    NeoColumn = '120',
    custom_NeoColumn = {
      markdown = '92', -- GitHub's rendering width
    },
  },
}
