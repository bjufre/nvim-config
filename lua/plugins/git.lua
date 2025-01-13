return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      local icons = require("bjufre.icons")

      require("gitsigns").setup({
        signs = {
          add = { text = icons.ui.BoldLineLeft },
          change = { text = icons.ui.BoldLineLeft },
          delete = { text = icons.ui.TriangleShortArrowRight },
          topdelete = { text = icons.ui.TriangleShortArrowRight },
          changedelete = { text = icons.ui.BoldLineLeft },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        status_formatter = nil,
        update_debounce = 200,
        max_file_length = 40000,
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          vim.keymap.set(
            "n",
            "<leader>H",
            require("gitsigns").preview_hunk,
            { buffer = bufnr, desc = "Preview git hunk" }
          )
          vim.keymap.set(
            "n",
            "<leader>gb",
            require("gitsigns").toggle_current_line_blame,
            { buffer = bufnr, desc = "Toggle Git Blame (Line)" }
          )

          vim.keymap.set("n", "]]", require("gitsigns").next_hunk, { buffer = bufnr, desc = "Next git hunk" })
          vim.keymap.set("n", "[[", require("gitsigns").prev_hunk, { buffer = bufnr, desc = "Previous git hunk" })
        end,
      })
    end,
  },
  {
    "sindrets/diffview.nvim", -- optional - Diff integration
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<CMD>LazyGit<CR>", desc = "LazyGit" },
    },
  },
}
