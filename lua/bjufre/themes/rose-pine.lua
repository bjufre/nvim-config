local DISABLE_ITALICS = true

local palette = require("rose-pine.palette")

require("rose-pine").setup({
  --- @usage 'auto'|'main'|'moon'|'dawn'
  variant = "moon",
  --- @usage 'main'|'moon'|'dawn'
  dark_variant = "moon",
  bold_vert_split = false,
  dim_nc_background = false,
  disable_background = false,
  disable_float_background = false,
  disable_italics = DISABLE_ITALICS,

  --- @usage string hex value or named color from rosepinetheme.com/palette
  groups = {
    background = "base",
    background_nc = "_experimental_nc",
    panel = "surface",
    panel_nc = "base",
    border = "highlight_med",
    comment = "muted",
    link = "iris",
    punctuation = "subtle",

    error = "love",
    hint = "iris",
    info = "foam",
    warn = "gold",

    headings = {
      h1 = "iris",
      h2 = "foam",
      h3 = "rose",
      h4 = "gold",
      h5 = "pine",
      h6 = "foam",
    },
    -- or set all headings at once
    -- headings = 'subtle'
  },

  -- Change specific vim highlight groups
  -- https://github.com/rose-pine/neovim/wiki/Recipes
  highlight_groups = {
    Italic = { italic = true },
    Comment = { italic = true },
    Keyword = { italic = false },
    Function = { italic = false },
    Variable = { italic = false },
    String = { italic = true },
    ["@string"] = { italic = true },

    -- This fixes a few issues, specially with Elixir atoms
    Identifier = { fg = palette.iris },

    -- Blend colours against the "base" background
    ColorColumn = { bg = palette.foam, blend = 10 },
    CursorLine = { bg = palette.foam, blend = 10 },
    StatusLine = { fg = palette.love, bg = "love", blend = 10 },

    -- Whitespace
    NonText = { fg = palette.highlight_high },
    IblIndent = { fg = palette.highlight_high },
    IblScope = { fg = palette.muted },

    -- Cursor
    Cursor = { fg = palette.base, bg = palette.pine },
    nCursor = { fg = palette.base, bg = palette.pine },
    iCursor = { fg = palette.base, bg = palette.love },
  },
  before_highlight = function(group, highlight, palette)
    -- Disable all undercurls
    -- if highlight.undercurl then
    --     highlight.undercurl = false
    -- end
    --
    -- Change palette colour
    -- if highlight.fg == palette.pine then
    --     highlight.fg = palette.foam
    -- end
  end,
})

-- Set colorscheme after options
vim.cmd("colorscheme rose-pine")
