return {
  {
    "windwp/nvim-autopairs",
    -- dependencies = {
    --   "hrsh7th/nvim-cmp",
    -- },
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_micro = false, -- disable when recording or execuring macro
        disable_in_visual_block = false, -- disable when insert after visual block mode
        ignored_next_char = [=[[%w%%%'[%"%.]]]=],
        enable_moveright = true,
        enable_afterquote = true, -- add bracket after quote
        enable_check_bracket_line = true, -- check bracket in same line
        enable_bracket_in_quote = true,
        enable_abbr = false, -- trigger abbr
        break_undo = true, -- switch for  basic rule break undo sequence
        check_ts = true,
        map_cr = true,
        map_bs = true, -- map <BS> key
        map_c_h = false, -- map <C-h> key to delete pair
        map_c_w = false, -- map <C-w> key to delete pair if possible
        -- Extra for TS server
        ts_config = {
          javascript = { "string", "template_string" }, -- it will not add a pair on that treesitter node
        },
      })

      -- Add support for cmp
      -- https://github.com/windwp/nvim-autopairs#you-need-to-add-mapping-cr-on-nvim-cmp-setupcheck-readmemd-on-nvim-cmp-repo
      -- require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
    end,
  },
}
