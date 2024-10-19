local p = require("poimandres.palette")

require("poimandres").setup({
  bold_vert_split = false, -- use bold vertical separators
  dim_nc_background = true, -- dim 'non-current' window backgrounds
  disable_background = false, -- disable background
  disable_float_background = false, -- disable background for floats
  disable_italics = false, -- disable italics
  groups = {
    border = p.background1,
  },
  highlight_groups = {
    LspReferenceText = { bg = p.background1 },
    LspReferenceRead = { bg = p.background1 },
    LspReferenceWrite = { bg = p.background1 },
    -- Whitespace
    NonText = { fg = p.background1 },
    IblIndent = { fg = p.background1 },
    IblScope = { fg = p.background1 },

    SpecialComment = { fg = p.blueGray1 }, -- special things inside a comment
    Comment = { fg = p.blueGray3 }, -- (preferred) any special symbol

    ColorColumn = { bg = p.background1 },
    CursorLine = { bg = p.background1 },
    Normal = { bg = p.background3 },
  },
})

-- vim.g.poimandres_variant = "storm" -- storm, dark

vim.cmd("colorscheme poimandres")
