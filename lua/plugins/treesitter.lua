return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
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

      local ts = require("nvim-treesitter")
      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      local parsers = {
        "bash",
        "css",
        "eex",
        "elixir",
        "embedded_template",
        "erlang",
        "gitignore",
        "gleam",
        "go",
        "heex",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "kdl",
        "lua",
        "markdown",
        "markdown_inline",
        "pug",
        "ruby",
        "scss",
        "sql",
        "templ",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      }

      vim.treesitter.language.register("bash", { "sh", "zsh" })
      vim.treesitter.language.register("eex", "eelixir")
      vim.treesitter.language.register("embedded_template", "eruby")
      vim.treesitter.language.register("tsx", { "javascriptreact", "typescriptreact" })
      vim.treesitter.language.register("vimdoc", "help")

      ts.install(parsers)

      local disabled_indent = { vue = true, rust = true }
      local filetypes = {
        "css",
        "eex",
        "eelixir",
        "elixir",
        "erlang",
        "eruby",
        "gitignore",
        "gleam",
        "go",
        "heex",
        "help",
        "html",
        "javascript",
        "javascriptreact",
        "jsdoc",
        "json",
        "kdl",
        "lua",
        "markdown",
        "pug",
        "ruby",
        "scss",
        "sh",
        "sql",
        "templ",
        "toml",
        "typescript",
        "typescriptreact",
        "vim",
        "vue",
        "yaml",
        "zsh",
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
          local ft = vim.bo.filetype
          local ok = pcall(vim.treesitter.start)
          -- Only set indentexpr if treesitter started successfully
          if ok and not disabled_indent[ft] then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.keymap.set("n", "<C-space>", "van", { desc = "Start node selection", remap = true })
      vim.keymap.set("v", "<C-space>", "an", { desc = "Grow node selection", remap = true })
      vim.keymap.set("v", "<C-s>", "an", { desc = "Grow node selection", remap = true })
      vim.keymap.set("v", "<C-BS>", "in", { desc = "Shrink node selection", remap = true })
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
