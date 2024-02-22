return {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        -- pre_hook = function()
        --   return require('ts_context_commentstring.internal').calculate_commentstring()
        -- end,
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        post_hook = nil,

        ---Add a space b/w comment and the line
        ---@type boolean
        padding = true,

        ---Lines to be ignored while comment/uncomment.
        ---Could be a regex string or a function that returns a regex string.
        ---Example: Use '^$' to ignore empty lines
        ---@type string|function
        ignore = "^$",

        ---Whether to create basic (operator-pending) and extra mappings for NORMAL/VISUAL mode
        ---@type table
        mappings = {
          ---operator-pending mapping
          ---Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
          basic = true,
          ---Extra mapping
          ---Includes `gco`, `gcO`, `gcA`
          extra = true,
          ---Extended mapping
          ---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
          extended = false,
        },

        ---LHS of extra mappings
        ---@type table
        extra = {
          ---Add comment on the line above
          above = "<leader>cO",
          ---Add comment on the line below
          below = "<leader>co",
          ---Add comment at the end of line
          eol = "<leader>ca",
        },

        ---LHS of line and block comment toggle mapping in NORMAL/VISUAL mode
        ---@type table
        toggler = {
          ---line-comment toggle
          line = "<leader>cc",
          ---block-comment toggle
          block = "<leader>cb",
        },

        ---LHS of line and block comment operator-mode mapping in NORMAL/VISUAL mode
        ---@type table
        opleader = {
          ---line-comment opfunc mapping
          line = "<leader>c",
          ---block-comment opfunc mapping
          block = "<leader>b",
        },
      })
    end,
  },
}
