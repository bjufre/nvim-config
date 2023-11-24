return {
  "rgroli/other.nvim",
  config = function()
    require("other-nvim").setup({
      mappings = {
        "rails",
        "laravel",
        -- Elixir
        {},

        -- Elixir => Phoenix
        {},
      },
    })
  end,
  keys = {
    { "<leader>oo", ":Other<CR>" },
    { "<leader>ot", ":Other test<CR>" },
  },
}
