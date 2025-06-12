return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    dependencies = {
      "saghen/blink.cmp",
      {
        "mhanberg/output-panel.nvim",
        enabled = false,
        version = "*",
        event = "VeryLazy",
        config = function()
          require("output_panel").setup({
            max_buffer_size = 5000, -- default
          })
        end,
        cmd = { "OutputPanel" },
        keys = {
          {
            "<leader>op",
            vim.cmd.OutputPanel,
            mode = "n",
            desc = "Toggle the output panel",
          },
        },
      },

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
        enabled = true,
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
                -- vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
                -- vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
                -- vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
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

      -- local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"

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
        ts_ls = {
          init_options = {},
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        -- vue_ls = {},

        -- Elixir
        -- TODO: Replace this once the official LSP is out
        -- elixirls = {},

        -- gleam = {},
        -- rust_analyzer = {},
        -- zls = {},
      }

      local servers_ensure_installed = vim.tbl_extend("force", vim.tbl_keys(servers), {
        "dockerls",
        "sqlls",
        "taplo",

        "eslint",
      })
      local tools_ensure_installed = vim.tbl_extend("force", vim.tbl_keys(servers), {
        "prettier",
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
      require("mason-tool-installer").setup({ ensure_installed = tools_ensure_installed })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = servers_ensure_installed,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      require("lspconfig").volar.setup({
        init_options = {
          vue = { hybridMode = false },
          -- typescript = {
          --   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
          -- },
        },
        settings = {
          typescript = {
            inlayHints = {
              enumMemberValues = {
                enabled = true,
              },
              functionLikeReturnTypes = {
                enabled = true,
              },
              propertyDeclarationTypes = {
                enabled = true,
              },
              parameterTypes = {
                enabled = true,
                suppressWhenArgumentMatchesName = true,
              },
              variableTypes = {
                enabled = true,
              },
            },
          },
        },
        -- filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
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
