local opt = vim.opt

opt.filetype = "utf-8"
opt.showmode = true
opt.showcmd = false
opt.cmdheight = 0 -- Height of the command bar
opt.hlsearch = false
opt.incsearch = true -- Makes searc act like search in modern browsers
opt.number = true
opt.relativenumber = true
opt.ignorecase = true -- Ignore case when searching
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.smartcase = true -- unless there's a capital letter in the query
opt.hidden = true -- buffers stay around
opt.equalalways = true -- Don't let windows change all the time
opt.splitright = true -- Make sure that vertical splits happen to the right
opt.splitbelow = true -- Make sure that horizontal splits happen below
opt.updatetime = 50 -- Make updates happen faster
opt.scrolloff = 99999 -- Make sure that we're always centered horizontally on the screen
opt.cursorline = true -- Highlight the current line
opt.numberwidth = 4 -- Leave some space for the numbers column (gutter)
opt.signcolumn = "yes" -- fixes most of the problematic issues with diagnostics to avoid shifting the character grid and get dizzy
opt.list = true
-- opt.listchars = "eol:↵,trail:~"
-- opt.listchars = "eol:↲,trail:·,tab:» ,nbsp:␣"
-- opt.listchars = "eol:↲,trail:·,tab:› ,nbsp:␣"
opt.listchars = "eol:↲,trail:·,tab:  ,nbsp:␣"
-- opt.listchars = "eol:↴,trail:~"
-- opt.colorcolumn = '80'
opt.colorcolumn = "120"

-- opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
-- BLOCK ALWAYS
-- opt.guicursor =
--   "n-v-c:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:block,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"

-- BLOCK ALWAYS (with different colors based on mode)
-- The colors are set in the `autocmds.lua` file.
-- opt.guicursor =
-- "n-v-c:block-nCursor-blinkwait700-blinkoff400-blinkon250,i-ci-ve:block-iCursor,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"

-- BLOCK & THIN
opt.guicursor =
  -- "n-v-c:block-nCursor-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver50-iCursor,r-cr:hor20,o:hor50,sm:block-blinkwait175-blinkoff150-blinkon175"
  "n-v-c:block-nCursor,i-ci-ve:ver50-iCursor,r-cr:hor20,o:hor50,sm:" -- No blinking

-- BLOCK & UNDER
-- opt.guicursor = "n-v-c:block-nCursor,i-ci-ve:hor20-iCursor,r-cr:hor20,o:hor50,sm:" -- No blinking

opt.backup = false
opt.swapfile = false -- Leaving on the edge
-- opt.undodir = os.getenv('HOME') .. './.vim/undodir'
-- opt.undofile = true
opt.termguicolors = true

-- Tabs
opt.autoindent = true
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2 -- Number of spaces inserted with each indentation

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 9999
-- opt.foldlevel = 0
-- opt.foldlevel = 9999
-- opt.foldenable = true
opt.modelines = 1

opt.wrap = false
opt.belloff = "all"
opt.mouse = "n" -- No mouse in nvim land
opt.clipboard = "unnamedplus" -- Use the system's clipboard

-- Make sure that we don't add two spaces when joining lines
opt.joinspaces = false

opt.list = true
-- vim.opt.listchars:append "space: "
-- vim.opt.listchars:append "tab: "
-- vim.opt.listchars:append "eol:↴"

-- Netrw options
vim.g.netrw_keepdir = 0
vim.g.netrw_banner = 1
