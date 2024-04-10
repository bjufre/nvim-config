return {
  "windwp/nvim-spectre",
  enabled = true,
  -- Use the defaults for now.
  -- Check this for more detailed information about those:
  -- https://github.com/nvim-pack/nvim-spectre#customize
  config = function()
    require("spectre").setup({
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          -- default args
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "Ignore case",
            },
            ["hidden"] = {
              value = "--hidden",
              icon = "[H]",
              desc = "Hidden file",
            },
          },
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "hidden" },
        },
      },
    })

    local map = require("bjufre.keymaps").remap
    local spectre = require("spectre")

    map("n", "<leader>sr", spectre.open, { desc = "[S]earch & [R]eplace" })
    map("n", "<leader>sw", function()
      spectre.open_visual({ select_word = true })
    end, { desc = "[S]earch & Replace [W]ord" })
    map("n", "<leader>sb", spectre.open_file_search, { desc = "[S]earch & Replace in [B]uffer" })
  end,
  -- keys = {
  --   {
  --     "<leader>se",
  --     function()
  --       require("spectre").open()
  --     end,
  --   },
  --   {
  --     "<leader>sf",
  --     function()
  --       require("spectre").open_file_search()
  --     end,
  --   },
  --   {
  --     "<leader>sw",
  --     function()
  --       require("spectre").open_file_search({ select_word = true })
  --     end,
  --   },
  -- },
}
