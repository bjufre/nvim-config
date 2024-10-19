return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon.setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = false,
      },
    })

    local telescope_conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = telescope_conf.file_previewer({}),
          sorter = telescope_conf.generic_sorter({}),
        })
        :find()
    end

    local map = require("bjufre.keymaps").remap

    map("n", "<leader>fh", function()
      toggle_telescope(harpoon:list())
    end, { desc = "[F]ind [H]arpoon marks" })
    map("n", "<leader>ha", function()
      harpoon:list():add()
    end, { desc = "[H]arpoon [A]dd" })
    map("n", "<leader>hh", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "[H]arpoon List" })
    map("n", "<C-m>", function()
      harpoon:list():select(1)
    end, { desc = "[H]arpoon Select(1)" })
    map("n", "<C-n>", function()
      harpoon:list():select(2)
    end, { desc = "[H]arpoon Select(2)" })
    map("n", "<C-e>", function()
      harpoon:list():select(3)
    end, { desc = "[H]arpoon Select(3)" })
    map("n", "<C-i>", function()
      harpoon:list():select(4)
    end, { desc = "[H]arpoon Select(4)" })
    map("n", "<C-o>", function()
      harpoon:list():select(5)
    end, { desc = "[H]arpoon Select(5)" })
  end,
}
