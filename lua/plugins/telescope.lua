return {
  -- Telescope
  "nvim-telescope/telescope-media-files.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "0.1.4",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg", -- find command (defaults to `fd`)
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("media_files")
    end,
    keys = {
      {
        "<leader>p",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = false })
        end,
      },
      {
        "<leader>f",
        function()
          require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
        end,
      },
      {
        "<leader>b",
        function()
          require("telescope.builtin").buffers({ only_cwd = true })
        end,
      },
      {
        "<leader>dd",
        function()
          require("telescope.builtin").diagnostics()
        end,
      },
      {
        "<leader>r",
        function()
          require("telescope.builtin").lsp_references()
        end,
      },
      -- {
      --   "<leader>dws",
      --   function()
      --     require("telescope.builtin").lsp_dynamic_workspace_symbols()
      --   end,
      -- },
      -- {
      --   "<leader>ds",
      --   function()
      --     require("telescope.builtin").lsp_document_symbols()
      --   end,
      -- },
      -- { '<leader>h', '<cmd>Telescope harpoon marks<CR>' },
      { "<leader>/", require("telescope.builtin").live_grep },
    },
  },
}
