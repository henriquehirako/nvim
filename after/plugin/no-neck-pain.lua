local nnp = require("no-neck-pain")

local options = {
  debug = false,
  width = 160,
  minSideBufferWidth = 0,
  disableOnLastBuffer = false,
  killAllBuffersOnDisable = false,
  autocmds = {
    enableOnVimEnter = false,
    enableOnTabEnter = false,
    reloadOnColorSchemeChange = false,
  },
  mappings = {
    enabled = true,
    toggle = "<Leader>g",
    widthUp = "<Leader>g=",
    widthDown = "<Leader>g-",
    scratchPad = false,
  },
  buffers = {
    setNames = false,
    scratchPad = NoNeckPain.bufferOptionsScratchpad,
    colors = NoNeckPain.bufferOptionsColors,
    bo = NoNeckPain.bufferOptionsBo,
    wo = NoNeckPain.bufferOptionsWo,
    left = NoNeckPain.bufferOptions,
    right = NoNeckPain.bufferOptions,
    -- right = { enabled = false }
  },
  integrations = {
    NvimTree = {
      position = "left",
      reopen = true,
    },
  },
}

NoNeckPain.bufferOptions = {
  enabled = false,
  colors = NoNeckPain.bufferOptionsColors,
  bo = NoNeckPain.bufferOptionsBo,
  wo = NoNeckPain.bufferOptionsWo,
  scratchPad = NoNeckPain.bufferOptionsScratchpad,
}

NoNeckPain.bufferOptionsWo = {
  cursorline = false,
  cursorcolumn = false,
  colorcolumn = "#000000",
  number = true,
  relativenumber = true,
  foldenable = false,
  list = false,
  wrap = false,
  linebreak = false,
}

NoNeckPain.bufferOptionsBo = {
  filetype = "no-neck-pain",
  buftype = "nofile",
  bufhidden = "hide",
  buflisted = false,
  swapfile = false,
}

NoNeckPain.bufferOptionsScratchpad = {
  enabled = false,
  fileName = "no-neck-pain",
  location = "~/Dev/Personal/2nd-brain/",
}

NoNeckPain.bufferOptionsColors = {
  background = nil,
  blend = 0,
  text = nil,
}

-- nnp.setup(options)
