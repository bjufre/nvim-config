return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",

      -- LSP Support
      { "williamboman/mason.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Needed so that we can use the amazing power of Telescope for the `on_attach`
      "nvim-telescope/telescope.nvim",

      -- KDL (Zellij config mainly)
      {
        "imsnif/kdl.vim",
        enabled = false,
      },

      -- Custom
      -- TODO: Figure out why this errors everytime we start NVIM
      -- { "sheerun/vim-polyglot" },

      {
        "amadeus/vim-mjml",
        enabled = false,
        filetypes = { "mjml" },
      },
      {
        "mhanberg/output-panel.nvim",
        enabled = false,
        event = "VeryLazy",
        config = function()
          require("output_panel").setup()
        end,
      },

      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")

          require("statuscol").setup({
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },

      -- Ruby/Rails
      "slim-template/vim-slim",

      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip").filetype_extend("ruby", { "rails" })
        end,
      },

      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "elixir-tools/elixir-tools.nvim",
        enabled = false,
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          local elixir = require("elixir")
          local elixirls = require("elixir.elixirls")

          elixir.setup({
            nextls = { enable = true },
            elixirls = {
              enable = true,
              settings = elixirls.settings({
                dialyzerEnabled = false,
                enableTestLenses = false,
              }),
              on_attach = function(client, bufnr)
                vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
              end,
            },
            projectionist = {
              enable = true,
            },
          })
        end,
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("bj-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map("gd", require("telescope.builtin").lsp_definitions, "[G]o to [D]efinition")
          -- Find references for the word under your cursor.
          map("gr", require("telescope.builtin").lsp_references, "[G]o to [R]eferences")
          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gI", require("telescope.builtin").lsp_implementations, "[G]o to [I]mplementation")
          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("<leader>T", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Open the diagnostic float to read the entire message
          map("<leader>od", vim.diagnostic.open_float, "[O]pen [D]iagnostic")

          -- CUSTOM restart function
          map("<leader>lr", require("bjufre.lsp.restart"), "[R]estart")

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(), {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
          -- Disable snippet support to remove LSP snippets and only have
          -- the ones that we explicitly created.
          completion = {
            completionItem = {
              snippetSupport = false,
            },
          },
        },
      })
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        html = {
          filetypes = { "html", "erb", "eruby", "eelixir", "html", "liquid", "heex", "templ", "css" },
          settings = {},
          init_options = {
            embeddedLanguages = { css = true, javascript = true },
            configurationSection = { "html", "css", "javascript" },
          },
        },
        htmx = {
          filetypes = { "html", "templ" },
        },
        cssls = {
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        tailwindcss = {
          init_options = {
            userLanguages = {
              eruby = "erb",
              templ = "html",
              heex = "phoenix-heex",
              elixir = "phoenix-heex",
            },
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  [[class: "([^"]*)]],
                },
              },
            },
          },
          filetypes = {
            "ruby",
            "erb",
            "eruby",
            "elixir",
            "eelixir",
            "html",
            "liquid",
            "heex",
            "css",
            "slim",
            "haml",
            "vue",
          },
        },
        -- ruby_lsp = {},
        -- rubocop = {
        --   filetypes = { "ruby", "slim" },
        --   cmd = {
        --     "bundle",
        --     "exec",
        --     "rubocop",
        --     "--lsp",
        --   },
        -- },
        ts_ls = {
          -- cmd = {
          --   "/Users/bj/Library/pnpm/tsserver",
          --   "-stdio",
          -- },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "/Users/bj/Library/pnpm/global/5/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        },
        -- Elixir
        -- TODO: Replace this onec the official LSP is out
        --
        elixirls = {
          cmd = { "/Users/bj/.local/share/nvim/mason/bin/elixir-ls" },
          settings = {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
        },
        -- lexical = {
        -- cmd = { "/Users/bj/.local/share/nvim/mason/bin/lexical" },
        --   root_dir = function(fname)
        --     return require("lspconfig.util").root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
        --   end,
        --   filetypes = { "elixir", "eelixir", "heex" },
        --   -- optional settings
        --   settings = {},
        -- },
        -- nextls = {
        --   cmd = { "/Users/bj/.local/share/nvim/mason/bin/nextls" },
        --   --   cmd = { "nextls", "--stdio" },
        --   init_options = {
        --     extensions = {
        --       credo = { enable = true },
        --     },
        --     experimental = {
        --       completions = { enable = true },
        --     },
        --   },
        -- },
        -- gleam = {},
        rust_analyzer = {},

        -- Zig
        zls = {},
      }

      local ensure_installed = vim.tbl_keys(servers)

      vim.list_extend(ensure_installed, {
        "intelephense",
        "dockerls",
        "sqlls",
        "taplo",

        "volar",
        "eslint",
        "prettier",

        "gopls",
        "templ",
        "stylua",
        "erb-formatter",
      })

      -- Make sure that we have "temp" support for Neovim filetypes
      vim.filetype.add({ extension = { templ = "templ" } })

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      require("lspconfig").gleam.setup({ capabilities = capabilities })

      require("lspconfig").ruby_lsp.setup({
        capabilities = capabilities,
        init_options = {
          formatter = "standard",
          linters = { "standard" },
        },
        addonSettings = {
          ["Ruby LSP Rails"] = {},
        },
        cmd = {
          "mise",
          "x",
          "--",
          "ruby-lsp",
        },
      })
      require("lspconfig").rubocop.setup({
        capabilities = capabilities,
        filetypes = { "ruby", "slim" },
        cmd = {
          "bundle",
          "exec",
          "rubocop",
          "--lsp",
        },
      })

      vim.diagnostic.config({ virtual_text = true })
    end,
  },
}
