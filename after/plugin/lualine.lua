require('lualine').setup({
  sections = {
    lualine_a = {
      {
        'mode',
        icons_enabled = true, 
      },
      {
        'filename',
        file_status = true,      -- Displays file status (readonly status, modified status)
        newfile_status = false,  -- Display new file status (new file means no write after created)
        path = 1,
      }
    }
  }
})
