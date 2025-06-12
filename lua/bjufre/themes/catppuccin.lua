require("catppuccin").setup({
  flavour = "macchiato", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  transparent_background = false,
  term_colors = false,
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.15,
  },
  no_italic = false, -- Force no italic
  no_bold = false, -- Force no bold
  styles = {
    comments = { "italic" },
    -- comments = {},
    -- conditionals = { "italic" },
    conditionals = {},
    loops = {},
    -- functions = { "italic" },
    -- functions = {},
    -- keywords = { "italic" },
    keywords = {},
    -- strings = { "italic" },
    strings = {},
    -- variables = { "italic" },
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    -- types = { "italic" },
    types = {},
    operators = {},
  },
  color_overrides = {},
  custom_highlights = function(palette)
    return {
      -- Whitespace
      NonText = { fg = palette.surface1 },
      IblIndent = { fg = palette.surface1 },
      IblScope = { fg = palette.surface2 },
      -- BlinkCmpMenu = {},
      -- BlinkCmpBorder = { fg = palette.text },
    }
  end,
  integrations = {
    blink_cmp = true,
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    telescope = true,
    notify = false,
    mini = true,
    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  },
})

vim.cmd([[colorscheme catppuccin]])
