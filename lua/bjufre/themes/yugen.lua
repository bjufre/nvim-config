local p = require("yugen.palette")

require("yugen").setup({
  bold_vert_split = false,
  dark_variant = "main",
  disable_background = false,
  disable_float_background = false,
  disable_italics = false,
  dim_nc_background = true,

  groups = {
    background = p.color800,
    panel = p.color800,
    border = p.color600,
    comment = p.color500,
    link = p.color200,
    punctuation = p.color500,

    error = p.error,
    hint = p.success,
    info = p.color200,
    warn = p.warning,

    git_add = p.color200,
    git_change = p.color600,
    git_delete = p.color200,
    git_dirty = p.color200,
    git_ignore = p.color600,
    git_merge = p.color200,
    git_rename = p.color200,
    git_stage = p.color200,
    git_text = p.color200,

    headings = {
      h1 = p.color400,
      h2 = p.color400,
      h3 = p.color400,
      h4 = p.color400,
      h5 = p.color400,
      h6 = p.color400,
    },
  },

  highlight_groups = {
    Normal = { bg = p.color800 },
    NormalNC = { bg = p.color800 },
    -- ColorColumn = { bg = p.color700 },
    -- CursorLine = { bg = p.color700 },

    -- LspReferenceText = { bg = p.background1 },
    -- LspReferenceRead = { bg = p.background1 },
    -- LspReferenceWrite = { bg = p.background1 },
    -- Whitespace
    NonText = { fg = p.color600 },
    IblIndent = { fg = p.color600 },
    IblScope = { fg = p.color600 },

    -- SpecialComment = { fg = p.color500 }, -- special things inside a comment
    -- Comment = { fg = p.color600 }, -- (preferred) any special symbol
  },
})

vim.cmd.colorscheme("yugen")
