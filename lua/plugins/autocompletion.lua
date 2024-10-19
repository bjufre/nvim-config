return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp-signature-help",
  },
  config = function()
    vim.opt.completeopt = { "menu", "menuone", "noselect" }

    local ls = require("luasnip")
    local cmp = require("cmp")
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

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
        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col(".") - 1

          if cmp.visible() then
            cmp.select_next_item({ behavior = "insert" })
          elseif ls.locally_jumpable(1) then
            ls.jump(1)
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
          else
            cmp.complete()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = "insert" })
          elseif ls.locally_jumpable(-1) then
            ls.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end,
        },
        -- { name = "nvim_lsp_signature_help" }, -- This will help show the popup for the signature docs
        { name = "luasnip" }, -- Disable snippets...
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
          local remove_source = true
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

    require("bjufre.snippets.elixir")

    require("bjufre.keymaps").remap(
      "n",
      "<leader><leader>s",
      "<CMD>source ~/.config/nvim/lua/plugins/autocompletion.lua<CR>",
      { desc = "[S]ource snippets" }
    )
  end,
}
