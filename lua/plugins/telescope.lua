return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-media-files.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local trouble = require("trouble")
      local icons = require("bjufre.icons")
      local lga_actions = require("telescope-live-grep-args.actions")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })

      local function formattedName(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        end
        return string.format("%s\t\t%s", tail, parent)
      end

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              -- ["<esc>"] = actions.close,
              ["<C-t>"] = trouble.open_with_trouble,
            },

            n = { ["<C-t>"] = trouble.open_with_trouble },
          },
          previewer = false,
          prompt_prefix = " " .. icons.ui.Telescope .. " ",
          selection_caret = icons.ui.BoldArrowRight .. " ",
          file_ignore_patterns = { "node_modules", "package-lock.json" },
          initial_mode = "insert",
          select_strategy = "reset",
          sorting_strategy = "ascending",
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          layout_config = {
            prompt_position = "top",
            preview_cutoff = 120,
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
        },
        pickers = {
          find_files = {
            previewer = false,
            path_display = formattedName,
            hidden = true, -- include hidden files, I want to see: `.formatter.exs`, etc.
            layout_config = {
              height = 0.4,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          git_files = {
            previewer = false,
            path_display = formattedName,
            layout_config = {
              height = 0.4,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          buffers = {
            path_display = formattedName,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["<c-d>"] = actions.delete_buffer,
              },
            },
            previewer = false,
            initial_mode = "normal",
            -- theme = "dropdown",
            layout_config = {
              height = 0.4,
              width = 0.6,
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          current_buffer_fuzzy_find = {
            previewer = true,
            layout_config = {
              prompt_position = "top",
              preview_cutoff = 120,
            },
          },
          live_grep = {
            find_cmd = "rg",
            only_sort_text = true,
            previewer = true,
          },
          grep_string = {
            only_sort_text = true,
            previewer = true,
          },
          lsp_references = {
            show_line = false,
            previewer = true,
          },
          treesitter = {
            show_line = false,
            previewer = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
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
          live_grep_args = {
            only_sort_text = true,
            previewer = true,
            auto_quoting = true,
            mappings = {
              ["<C-k>"] = function()
                lga_actions.quote_prompt()
              end,
              ["<C-i>"] = function()
                lga_actions.quote_prompt({ postfix = "--iglob" })
              end,
            },
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("refactoring")
      telescope.load_extension("media_files")
      telescope.load_extension("live_grep_args")
    end,
  },
}
