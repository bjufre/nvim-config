-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "echasnovski/mini.files",
  dependencies = {
    -- "folke/which-key.nvim",
  },
  enabled = false,
  config = function()
    require("mini.files").setup({
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = "q",
        go_in = "", -- "l"
        go_in_plus = "<CR>", -- "L"
        go_out = "<ESC>", -- "h"
        go_out_plus = "", -- "H"
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "<leader>w",
        trim_left = "<",
        trim_right = ">",
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    })
    --  Create mapping to show/hide dot-files ~

    -- Create an autocommand for `MiniFilesBufferCreate` event which calls
    -- |MiniFiles.refresh()| with explicit `content.filter` functions: >

    local show_dotfiles = true
    local filter_show = function(fs_entry)
      return true
    end
    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end
    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require("mini.files").refresh({ content = { filter = new_filter } })
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set("n", "h.", toggle_dotfiles, { buffer = buf_id })
      end,
    })
  end,
  keys = {
    {
      "-",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0))
      end,
    },
  },
}
