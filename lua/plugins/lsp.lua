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
    opts = {},
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
      { "sheerun/vim-polyglot" },
      { "simrat39/rust-tools.nvim" },
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
      { "stevearc/conform.nvim", enabled = true },
      {
        "mfussenegger/nvim-lint",
        enabled = true,
        events = {
          "BufReadPre",
          "BufNewFile",
        },
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
      local mason_tools_installer = require("mason-tool-installer")

      lsp.preset("lsp-compe")
      mason_tools_installer.setup({
        ensure_installed = {
          "html",
          "cssls",
          "emmet_ls",
          "dockerls",
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
          "rust_analyzer",
        },
      })

      vim.opt.completeopt = { "menu", "menuone", "noselect" }

      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      local cmp_config = lsp.defaults.cmp_config({
        completion = {
          -- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        },
        mapping = lsp.defaults.cmp_mappings({
          ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<C-e>"] = cmp.mapping.close(),
          ["<C-h>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")

            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-l>"] = cmp.mapping(function(fallback)
            local luasnip = require("luasnip")

            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = {
          {
            name = "nvim_lsp",
            entry_filter = function(entry, ctx)
              -- return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
            end,
          },
          { name = "nvim_lsp_signature_help" }, -- This will help show the popup for the signature docs
          -- { name = "luasnip" }, -- Disable snippets...
          { name = "path" },
          { name = "buffer", keyword_length = 5 }, -- Wait at least until I've written 5 characters to show buffer sugg.
        },
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
              luasnip = "[LuaSnip]",
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

      cmp.setup(cmp_config)

      lsp.on_attach(on_attach)

      lsp.configure("lua_ls", {
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
          },
        },
      })

      lsp.configure("cssls", {
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      lsp.configure("emmet_ls", {
        settings = {
          capabilities = capabilities,
          filetypes = {
            "css",
            "eruby",
            "heex",
            "eelixir",
            "html",
            "javascript",
            "javascriptreact",
            "less",
            "sass",
            "scss",
            "svelte",
            "pug",
            "typescriptreact",
            "vue",
          },
        },
      })

      lsp.setup_servers({
        opts = {
          handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
          },
        },
      })

      local rust_lsp = lsp.build_options("rust_analyzer", {
        single_file_support = false,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              -- Do not show the inactive diagnostic for `#[cfg]` attributes
              disabled = { "inactive-code" },
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
              attributes = {
                enable = true,
              },
            },
            checkOnSave = {
              enable = true,
              command = "clippy",
              extraArgs = "--fix",
            },
          },
        },
        on_attach = function(client, bufnr)
          local remap = vim.keymap.set
          local opts = { buffer = bufnr, noremap = true, silent = true }
          local rt = require("rust-tools")

          on_attach(client, bufnr)
          remap("n", "K", rt.hover_actions.hover_actions, opts)
          remap("n", "<leader>a", rt.code_action_group.code_action_group, opts)
          remap("n", "<leader>he", rt.inlay_hints.enable, opts)
          remap("n", "<leader>hd", rt.inlay_hints.disable, opts)
        end,
      })

      lsp.skip_server_setup({ "rust_analyzer" })
      lsp.skip_server_setup({ "elixir_ls", "elixirls" }) -- We're setting the new `nextls` server below

      lsp.setup()

      local js_formatters = { "eslint", "prettier" }
      require("conform").setup({
        format_on_save = {
          timeout = 500,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          lua = { "stylua" },
          toml = { "taplo" },
          ruby = { "rubocop" },

          vue = js_formatters,
          svelte = js_formatters,
          javascript = js_formatters,
          javascriptreact = js_formatters,
          typescript = js_formatters,
          typescriptreact = js_formatters,

          -- This will run in all files
          ["*"] = { "trim_whitespace" },
        },
      })

      local lint = require("lint")
      lint.linters_by_ft = {
        vue = { "eslint" },
        svelte = { "eslint" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },

        ruby = { "rubocop" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      -- We need to move this after the `lsp.setup()` otherwise it won't work
      require("bjufre.lsp.elixir").setup(on_attach)

      -- Configure Fuzzy LS Ruby server
      require("bjufre.lsp.ruby").setup(on_attach)

      require("rust-tools").setup({
        server = rust_lsp,
        tools = {
          inlay_hints = {
            auto = false,
          },
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
      })
    end,
  },
}
