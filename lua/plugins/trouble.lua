return {
  "folke/trouble.nvim",
  config = function()
    require("trouble").setup({
      auto_close = false,
      auto_preview = true,
      focus = false,
      modes = {
        diagnostics = {
          auto_open = false,
        },
      },
      keys = {
        ["?"] = "help",
        r = "refresh",
        q = "close",
        ["<cr>"] = "jump",
        ["<c-s>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
        ["<c-t>"] = "jump_tab",
        o = "jump_close",
        ["<esc>"] = "cancel",
        m = "toggle_mode",
        P = "toggle_preview",
        K = "hover",
        p = "preview",
        zM = "fold_close_all",
        zR = "fold_open_all",
        za = "fold_toggle",
      },
    })

    -- Keymaps for opening trouble
    local map = require("bjufre.keymaps").remap
    map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble: Diagnostics (all)" })
    map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble: Diagnostics (buffer)" })
    map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble: Location List" })
    map("n", "<leader>xq", "<cmd>Trouble quickfix toggle<cr>", { desc = "Trouble: Quickfix" })
    map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble: LSP References" })
    map("n", "<leader>xs", "<cmd>Trouble lsp_document_symbols toggle<cr>", { desc = "Trouble: Document Symbols" })
  end,
}
