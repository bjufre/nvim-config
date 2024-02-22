local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local remap = vim.keymap.set
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Mappings
  -- See `:h vim.lsp.*` for documentation on any of the following functions
  remap("n", "vgd", "<CMD>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
  remap("n", "vgD", "<CMD>vsplit | lua vim.lsp.buf.declaration()<CR>", opts)
  remap("n", "gd", vim.lsp.buf.definition, opts)
  remap("n", "gD", vim.lsp.buf.declaration, opts)
  remap("n", "<leader>k", vim.lsp.buf.hover, opts)
  remap("n", "<leader>a", vim.lsp.buf.code_action, opts)
  remap("n", "gi", vim.lsp.buf.implementation, opts)
  -- remap('n', 'go', function() vim.lsp.buf.type_definition() end, opts)
  remap("n", "gr", vim.lsp.buf.references, opts)
  remap("n", "rn", vim.lsp.buf.rename, opts)
  remap("n", "gpd", vim.diagnostic.goto_prev, opts)
  remap("n", "gnd", vim.diagnostic.goto_next, opts)
  remap({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, opts)
  remap("n", "<leader>-", vim.lsp.buf.format, opts)
end

return {
  {
    -- Needs to happen first in order to make sure that the hook is set for `sumneko_lua`
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        library = {
          enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
          -- these settings will be used for your Neovim config directory
          runtime = true, -- runtime path
          types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
          plugins = true, -- installed opt or start plugins in packpath
          -- you can also specify the list of plugins to make available as a workspace library
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
        -- for your Neovim config directory, the config.library settings will be used as is
        -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
        -- for any other directory, config.library.enabled will be set to false
        override = function(root_dir, options) end,
        -- With lspconfig, Neodev will automatically setup your lua-language-server
        -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
        -- in your lsp start options
        lspconfig = true,
        -- much faster, but needs a recent built of lua-language-server
        -- needs lua-language-server >= 3.6.0
        pathStrict = true,
      })
    end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- KDL (Zellij config mainly)
      { "imsnif/kdl.vim" },

      -- Custom
      -- TODO: Figure out why this errors everytime we start NVIM
      -- { "sheerun/vim-polyglot" },

      -- { "simrat39/rust-tools.nvim" },
      {
        "elixir-tools/elixir-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "amadeus/vim-mjml",
        enabled = true,
        filetypes = { "mjml" },
      },
      {
        "mhanberg/output-panel.nvim",
        event = "VeryLazy",
        config = function()
          require("output_panel").setup()
        end,
      },

      -- Symbols Outline
      {
        "simrat39/symbols-outline.nvim",
        enabled = false,
        opts = {
          auto_close = false,
          show_symbol_details = false,
          keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = { "<Esc>" },
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-space>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
            fold = "h",
            unfold = "l",
            fold_all = "W",
            unfold_all = "E",
            fold_reset = "R",
          },
        },
        keys = {
          { "<leader>so", ":SymbolsOutline<CR>" },
        },
      },

      -- Folding
      {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
          require('bjufre.ufo').setup()
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

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },

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
    },
    config = function()
      local lsp = require("lsp-zero")

      lsp.set_server_config({
        capabilities = {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            }
          }
        },
        handlers = {
          ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
          ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
        },
      })

      lsp.on_attach(on_attach)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = {
          "html",
          -- "htmx",
          "cssls",
          "dockerls",
          -- FIXME: Issue with `Noice` where the buffer is overwritten with error log
          "rubocop",
          "solargraph",
          "tailwindcss",
          "sqlls",
          "taplo",
          "vuels",
          "tsserver",
          "eslint",
          "prettier",
          "lua_ls",
          -- "rust_analyzer",
          "gopls",
          "nextls",
          "elixirls",
        },
        handlers = {
          lsp.default_setup,
          lua_ls = function()
            require("lspconfig").lua_ls.setup(vim.tbl_deep_extend("force", lsp.nvim_lua_ls(), {
              settings = {
                Lua = {
                  hint = {
                    enable = true,
                  },
                },
              },
            }))
          end,
          html = function()
            require("lspconfig").html.setup({
              filetypes = { "html", "erb", "eruby", "eelixir", "html", "liquid", "heex", "css" },
              settings = {},
              init_options = {
                embeddedLanguages = { css = true, javascript = true },
                configurationSection = { "html", "css", "javascript" },
              },
            })
          end,
          cssls = function()
            require("lspconfig").cssls.setup({
              settings = {
                css = {
                  lint = {
                    unknownAtRules = "ignore",
                  },
                },
              },
            })
          end,
          tailwindcss = function()
            require("lspconfig").tailwindcss.setup({
              init_options = {
                userLanguages = {
                  elixir = "phoenix-heex",
                  eruby = "erb",
                  heex = "phoenix-heex",
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
              filetypes = { "erb", "eruby", "elixir", "eelixir", "html", "liquid", "heex", "css", "slim", "haml" },
            })
          end
        }
      })

      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_action = require("lsp-zero").cmp_action()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          -- FIXME: Scrolling docs doesn't work
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<C-e>"] = cmp.mapping.close(),
          ["<Tab>"] = cmp_action.tab_complete(),
          ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
        }),
        sources = {
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          -- { name = "nvim_lsp_signature_help" }, -- This will help show the popup for the signature docs
          -- { name = "luasnip" }, -- Disable snippets...
          { name = "path" },
          { name = "buffer", keyword_length = 5 }, -- Wait at least until I've written 5 characters to show buffer sugg.
        },
        -- formatting = lsp.cmp_format(),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            local icons = require("bjufre.icons").kind
            -- Kind icons
            vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
            -- Source
            local remove_source = false
            -- NOTE: Order matters
            local sources_menu = {
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              -- luasnip = "[LuaSnip]",
              buffer = "[Buffer]",
              path = "[Path]",
            }

            if remove_source then
              for key in pairs(sources_menu) do
                sources_menu[key] = ""
              end
            end

            vim_item.menu = sources_menu[entry.source.name]

            -- TODO: Add Tailwind colors CMP support

            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })


      -- We need to move this after the `lsp.setup()` otherwise it won't work
      require("bjufre.lsp.elixir").setup(on_attach)
      -- Configure Fuzzy LS Ruby server
      require("bjufre.lsp.ruby").setup(on_attach)

      vim.diagnostic.config({
        virtual_text = true,
      })
    end,
  },
}
