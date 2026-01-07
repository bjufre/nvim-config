return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-endwise",
    },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "xml",
          "php",
          "markdown",
          "glimmer",
          "handlebars",
          "hbs",
          "ruby",
          "eruby",
          "slim",
          "blade",
          "templ",
          "elixir",
          "heex",
          "embedded_template",
        },
      })

      vim.g.skip_ts_context_commentstring_module = true

      -- List of parsers to install
      local ensure_installed = {
        "vim",
        "vimdoc",
        "tsx",
        "html",
        "json",
        "lua",
        "css",
        "scss",
        "ruby",
        "erlang",
        "eex",
        "heex",
        "elixir",
        "gleam",
        "gitignore",
        "javascript",
        "typescript",
        "markdown",
        "markdown_inline",
        "pug",
        "sql",
        "toml",
        "vue",
        "yaml",
        "jsdoc",
        "go",
        "templ",
      }

      -- Install ensure_installed parsers on startup
      vim.schedule(function()
        for _, lang in ipairs(ensure_installed) do
          local ok = pcall(vim.treesitter.language.inspect, lang)
          if not ok then
            pcall(function()
              vim.cmd("TSInstall! " .. lang)
            end)
          end
        end
      end)

      -- Enable highlighting, indentation for supported filetypes
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ft = vim.bo.filetype
          -- Skip for these filetypes
          local disabled_indent = { vue = true, rust = true }

          pcall(vim.treesitter.start)

          if not disabled_indent[ft] then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Incremental selection keymaps
      vim.keymap.set("n", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").init_selection()
      end, { desc = "Start incremental selection" })
      vim.keymap.set("v", "<C-space>", function()
        require("nvim-treesitter.incremental_selection").node_incremental()
      end, { desc = "Increment selection" })
      vim.keymap.set("v", "<C-s>", function()
        require("nvim-treesitter.incremental_selection").scope_incremental()
      end, { desc = "Increment scope" })
      vim.keymap.set("v", "<C-BS>", function()
        require("nvim-treesitter.incremental_selection").node_decremental()
      end, { desc = "Decrement selection" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      patterns = {
        -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          "class",
          "function",
          "method",
          "for",
          "while",
          "if",
          "switch",
          "case",
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {
          "chapter",
          "section",
          "subsection",
          "subsubsection",
        },
        rust = {
          "impl_item",
          "struct",
          "enum",
        },
        scala = {
          "object_definition",
        },
        vhdl = {
          "process_statement",
          "architecture_body",
          "entity_declaration",
        },
        markdown = {
          "section",
        },
        ruby = {
          "method",
          "class",
          "block",
          "do_block",
        },
        elixir = {
          "anonymous_function",
          "arguments",
          "block",
          "do_block",
          "list",
          "map",
          "tuple",
          "quoted_content",
        },
        json = {
          "pair",
        },
        yaml = {
          "block_mapping_pair",
        },
      },
      exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
      },
      -- [!] The options below are exposed but shouldn't require your attention,
      --     you can safely ignore them.

      zindex = 20, -- The Z-index of the context window
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
    },
  },
}
