return {
  "nanozuki/tabby.nvim",
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("tabby").setup({
      preset = "tab_only",
      option = {
        nerdfont = true, -- whether use nerdfont
        lualine_theme = "rose-pine", -- lualine theme name
        tab_name = {
          -- name_fallback = function(tabid)
          --   return tabid
          -- end,
          override = nil,
        },
        buf_name = {
          -- mode = "'unique'|'relative'|'tail'|'shorten'",
          mode = "unique",
        },
      },
    })

    -- require("bjufre.keymaps").register({
    --   normal_mode = {
    --     ["<C-m>"] = "1gt",
    --     ["<C-n>"] = "2gt",
    --     ["<C-e>"] = "3gt",
    --     ["<C-i>"] = "4gt",
    --     ["<C-o>"] = "5gt",

    --     -- Move tabs
    --     ["<leader>tmn"] = ":+tabmove<CR>",
    --     ["<leader>tmp"] = ":-tabmove<CR>",
    --   },
    -- })
  end,
}
