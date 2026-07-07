return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true,
      disable_in_visual_block = false,
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      break_undo = true,
      check_ts = true,
      map_cr = true,
      map_bs = true,
      map_c_h = false,
      map_c_w = false,
    })
  end,
}
