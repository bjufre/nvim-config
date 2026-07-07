return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            "nvim-dap-ui",
            -- Load luvit types when the `vim.uv` word is found
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "/usr/share/awesome/lib/", words = { "awesome" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true },
      {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        cmd = "Mason",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
      -- { dir = "~/plugins/ocaml.nvim" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(nil, true)
      end

      local env = require("bjufre.env")

      local vue_language_server_path = vim.fn.stdpath("data")
        .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
      local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }

      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
        configNamespace = "typescript",
      }

      local servers = {
        bashls = true,
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        glsl_analyzer = true,
        lua_ls = {
          cmd = { "lua-language-server" },
          -- capability_overrides = {
          --   semanticTokensProvider = vim.NIL,
          -- },
        },
        rust_analyzer = true,
        -- svelte = true,
        templ = true,
        taplo = true,
        intelephense = {
          settings = {
            intelephense = {
              format = {
                braces = "k&r",
              },
            },
          },
        },

        -- Enabled biome formatting, turn off all the other ones generally
        biome = true,
        astro = true,
        vue_ls = env.with_node_path({}),
        -- tsgo = {
        --   init_options = {
        --     plugins = {
        --       vue_plugin,
        --     },
        --   },
        --   filetypes = tsserver_filetypes,
        -- },
        ts_ls = env.with_node_path({
          init_options = {
            plugins = {
              vue_plugin,
            },
          },
          filetypes = tsserver_filetypes,
        }),
        -- vtsls = {
        --   settings = {
        --     tsserver = {
        --       globalPlugins = {
        --         vue_plugin,
        --       },
        --     },
        --   },
        --   filetypes = tsserver_filetypes,
        -- },

        -- denols = true,
        jsonls = {
          capability_overrides = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        -- cssls = {
        --   capability_overrides = {
        --     documentFormattingProvider = false,
        --   },
        -- },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              -- schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        gleam = {
          manual_install = true,
        },

        -- TODO: Move to `expert` the official LSP server
        elixirls = {
          cmd = { "/Users/bj/.local/share/nvim/mason/bin/elixir-ls" },
          root_markers = { "mix.exs" },
        },

        tailwindcss = env.with_node_path({
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              eruby = "erb",
              heex = "phoenix-heex",
            },
          },
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "ocaml.mlx",
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  [[class: "([^"]*)]],
                  [[className="([^"]*)]],
                },
              },
              includeLanguages = {
                ["ocaml.mlx"] = "html",
              },
            },
          },
        }),
      }

      -- require("ocaml").setup()

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      local lsp_servers_to_install = vim.list_extend({
        "html",
        "cssls",
        "ruby_lsp",
        "dockerls",
        "sqlls",
        "eslint",
      }, servers_to_install)

      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers_to_install,
        automatic_enable = false,
      })

      local mr = require("mason-registry")
      local non_lsp_tools = {
        "stylua",
        "prettier",
        "erb-formatter",
        "delve",
      }

      mr.refresh(function()
        for _, tool in ipairs(non_lsp_tools) do
          local ok, pkg = pcall(mr.get_package, tool)
          if ok and not pkg:is_installed() then
            pkg:install()
          end
        end
      end)

      -- Set global capabilities for all LSP servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Configure and enable each LSP server
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end

        -- Only call vim.lsp.config if there are server-specific settings
        if next(config) ~= nil then
          -- Remove manual_install flag as it's not an LSP config field
          local lsp_config = vim.tbl_deep_extend("force", {}, config)
          lsp_config.manual_install = nil
          lsp_config.capability_overrides = nil
          vim.lsp.config(name, lsp_config)
        end

        vim.lsp.enable(name)
      end

      local disable_semantic_tokens = {
        -- lua = true,
      }

      -- vim.api.nvim_create_autocmd("CursorHold", {
      --   callback = function(_args)
      --     vim.diagnostic.open_float({ scope = "line" })
      --   end,
      -- })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require("telescope.builtin")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = 0 })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = 0 })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
          vim.keymap.set("n", "D", function()
            vim.diagnostic.open_float({ scope = "line" })
          end, { buffer = 0 })
          vim.keymap.set("n", "T", function()
            vim.lsp.buf.definition()
          end, { buffer = 0 })

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })
          vim.keymap.set("n", "<space>ds", builtin.lsp_document_symbols, { buffer = 0 })
          vim.keymap.set("n", "<space>dd", function()
            builtin.diagnostics({ root_dir = true })
          end, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.capability_overrides then
            for k, v in pairs(settings.capability_overrides) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
    end,
  },
}
