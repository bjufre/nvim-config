return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim',  "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require('harpoon')

    harpoon.setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = false,
      },
    })

    local telescope_conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers').new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table({
          results = file_paths,
        }),
        previewer = telescope_conf.file_previewer({}),
        sorter = telescope_conf.generic_sorter({})
      }):find()
    end

    require('bjufre.keymaps').register({
      normal_mode = {
        ["<leader>th"] = function()
          toggle_telescope(harpoon:list())
        end,
        ['<leader>ha'] = function() harpoon:list():append() end ,
        ['<leader>hh'] = function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        ['<C-n>'] = function() harpoon:list():select(1) end,
        ['<C-e>'] = function() harpoon:list():select(2) end,
        ['<C-i>'] = function() harpoon:list():select(3) end,
        ['<C-o>'] = function() harpoon:list():select(4) end,
      }
    })
  end,
}
