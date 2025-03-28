return {
  "niqodea/lasso.nvim",
  enabled = false,
  config = function()
    local lasso = require("lasso")

    lasso.setup({})

    require("bjufre.keymaps").register({
      normal_mode = {
        ["<C-m>"] = function()
          lasso.open_marked_file(1)
        end,
        ["<C-n>"] = function()
          lasso.open_marked_file(2)
        end,
        ["<C-e>"] = function()
          lasso.open_marked_file(3)
        end,
        ["<C-i>"] = function()
          lasso.open_marked_file(4)
        end,
        ["<C-o>"] = function()
          lasso.open_marked_file(5)
        end,

        -- Mark current file
        ["<leader>m"] = lasso.mark_file,
        -- Go to marks tracker (editable, use `gf` to go to file under cursor)
        ["<leader>M"] = lasso.open_marks_tracker,
      },
    })

    -- Create or jump to n-th terminal
    -- vim.keymap.set("n", vim.g.mapleader .. "<F1>", function()
    --   lasso.open_terminal(1)
    -- end)
    -- vim.keymap.set("n", vim.g.mapleader .. "<F2>", function()
    --   lasso.open_terminal(2)
    -- end)
    -- vim.keymap.set("n", vim.g.mapleader .. "<F3>", function()
    --   lasso.open_terminal(3)
    -- end)
    -- vim.keymap.set("n", vim.g.mapleader .. "<F4>", function()
    --   lasso.open_terminal(4)
    -- end)
  end,
}
