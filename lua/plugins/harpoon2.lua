return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon.setup({})

    require("bjufre.keymaps").register({
      normal_mode = {
        ["<C-m>"] = function()
          harpoon:list():select(1)
        end,
        ["<C-n>"] = function()
          harpoon:list():select(2)
        end,
        ["<C-e>"] = function()
          harpoon:list():select(3)
        end,
        ["<C-i>"] = function()
          harpoon:list():select(4)
        end,
        ["<C-o>"] = function()
          harpoon:list():select(5)
        end,
        ["<C-'>"] = function()
          harpoon:list():select(6)
        end,

        -- Mark current file
        ["<leader><leader>"] = function()
          harpoon:list():add()
        end,
        -- Go to marks tracker
        ["<leader>h"] = function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
      },
    })
  end,
}
