
-------------------------------
-- File Locations
-------------------------------
vim.cmd [[set backupdir=~/.config/nvim/.backup//]]
vim.cmd [[set directory=~/.config/nvim/.tmp//]]
vim.cmd [[set spellfile=~/.config/nvim/spell/custom.en.utf-8.add]]
vim.cmd [[set undofile]]
vim.cmd [[set undodir=~/.config/nvim/.undo]]

------------------
-- UI
------------------
vim.cmd [[set ruler]]           -- Ruler on
vim.cmd [[set number]]          -- Line numbers on
vim.cmd [[set relativenumber]]  -- Relative line numbers
vim.cmd [[set laststatus=2]]    -- Always show the statusline
vim.cmd [[set cursorline]]      -- Highlight current line
vim.cmd [[set encoding=UTF-8]]
vim.cmd [[set title]]           -- Set the title of the window in the terminal to the file
vim.cmd [[set ttyfast]]         -- higher refresh rate"
vim.cmd [[set lazyredraw]]      -- buffer screen updates"
vim.cmd [[set nowrap]]          -- Line wrapping off
vim.cmd [[set colorcolumn=120]] -- Color the 120th column differently as a wrapping guide.

------------------
-- Behaviors
------------------
vim.cmd [[syntax enable]]
vim.cmd [[set re=1]]                  -- Using new and faster regex system (fix slow ruby)

vim.cmd [[set backup]]                -- Turn on backups
vim.cmd [[set autoread]]              -- Automatically reload changes if detected

vim.cmd [[set wildmenu]]              -- Turn on WiLd menu
vim.cmd [[set wildmode=longest,full]] -- longest common part, then all.

vim.cmd [[set hidden]]             -- Change buffer - without saving
vim.cmd [[set history=768]]        -- Number of things to remember in history.
vim.cmd [[set confirm]]            -- Enable error files & error jumping.
vim.cmd [[set clipboard+=unnamed]] -- Yanks go on clipboard instead.
vim.cmd [[set autowrite]]          -- Writes on make/shell commands
-- set timeoutlen=400     " Time to wait for a command (after leader for example).
-- set ttimeout
-- set ttimeoutlen=100    " Time to wait for a key sequence.
vim.cmd [[set nofoldenable]]       -- Disable folding entirely.
vim.cmd [[set foldlevelstart=99]]  -- I really don't like folds.
vim.cmd [[set formatoptions=crql]]
vim.cmd [[set iskeyword+=\$,-]]    -- Add extra characters that are valid parts of variables
vim.cmd [[set nostartofline]]      -- Don't go to the start of the line after some commands
vim.cmd [[set scrolloff=3]]        -- Keep three lines below the last line when scrolling
vim.cmd [[set gdefault]]           -- this makes search/replace global by default
vim.cmd [[set switchbuf=useopen]]  -- Switch to an existing buffer if one exists

------------------
-- Text Format
------------------
vim.cmd [[set tabstop=2]]
vim.cmd [[set backspace=indent,eol,start]] -- Delete everything with backspace
vim.cmd [[set shiftwidth=2]]               -- Tabs under smart indent
vim.cmd [[set shiftround]]
vim.cmd [[set softtabstop=2]]
vim.cmd [[set cindent]]
vim.cmd [[set autoindent]]
vim.cmd [[set smarttab]]
vim.cmd [[set expandtab]]
vim.cmd [[set spell spelllang=en_us]]
vim.cmd [[set nospell]]

-----------------
-- Searching
-----------------
vim.cmd [[set ignorecase]] -- Case insensitive search
vim.cmd [[set smartcase]]  -- Non-case sensitive search
vim.cmd [[set incsearch]]  -- Incremental search
vim.cmd [[set hlsearch]]   -- Highlight search results
vim.cmd [[set wildignore+=*.o,*.obj,*.exe,*.so,*.dll,*.pyc,.svn,.hg,.bzr,.git,*.DS_Store,
  \.sass-cache,*.class,*.scssc,*.cssc,sprockets%*,*.lessc,
  \rake-pipeline-*]]

-----------------
-- Visual
-----------------
vim.cmd [[set showmatch]]   -- Show matching brackets.
vim.cmd [[set matchtime=2]] -- How many tenths of a second to blink
vim.cmd [[set list]]        -- Show invisible characters

-- Show trailing spaces as dots and carrots for extended lines.
-- From Janus, http://git.io/PLbAlw
-- Reset the listchars
vim.cmd [[set listchars=""]]

-- set listchars=tab:▸▸
vim.cmd [[set listchars+=tab:··]]  -- make tabs visible
vim.cmd [[set listchars+=trail:•]] -- show trailing spaces as dots

-- The character to show in the last column when wrap is off and the line
-- continues beyond the right of the screen
vim.cmd [[set listchars+=extends:>]]
-- The character to show in the last column when wrap is off and the line
-- continues beyond the right of the screen
vim.cmd [[set listchars+=precedes:<]]

-----------------
-- Sounds
-----------------
vim.cmd [[set noerrorbells]]
vim.cmd [[set visualbell]]
vim.cmd [[set t_vb=]]

-----------------
-- Mouse
-----------------
-- set mousehide  " Hide mouse after chars typed
-- set mouse=a    " Mouse in all modes

-- Better complete options to speed it up
vim.cmd [[set complete=.,w,b,u,U]]

-- Identing
vim.cmd [[set nocompatible]]      -- We're running Vim, not Vi!
vim.cmd [[filetype on]]           -- Enable filetype detection
vim.cmd [[filetype indent on]]    -- Enable filetype-specific indenting
vim.cmd [[filetype plugin on]]    -- Enable filetype-specific plugins

vim.cmd [[autocmd Filetype ruby setlocal ts=2 sw=2 expandtab]]
vim.cmd [[autocmd Filetype markdown setlocal colorcolumn=92]] -- Github limit
vim.cmd [[autocmd BufReadPost *.yaml.tpl set syntax=yaml]]
