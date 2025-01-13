return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        -- theme = "nordic",
        -- theme = "poimandres",
        theme = "rose-pine",
        -- theme = "catpuccin",
        -- theme = "nord",
        -- theme = bubbles_theme,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        -- lualine_b = { "filename", "branch" },
        lualine_b = { "filename" },
        lualine_c = {
          "%=", --[[ add your center components here in place of this comment ]]
        },
        lualine_x = {},
        -- lualine_y = { "filetype", "progress" },
        lualine_y = { "filetype" },
        lualine_z = {
          { "location", separator = { right = "" }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { "filename" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {},
      extensions = {},
    })
  end,
}
