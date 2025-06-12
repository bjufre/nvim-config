return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = "rafamadriz/friendly-snippets",

  -- use a release tag to download pre-built binaries
  version = "v0.*",
  -- version = "v1.*",

  build = "cargo build --release",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  config = function()
    local types = require("blink.cmp.types")

    require("blink.cmp").setup({
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = "default" },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = require("bjufre.icons").kind,
      },

      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        -- add lazydev to your completion providers
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },

      -- experimental signature help support
      signature = {
        enabled = true,
      },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { window = { border = "rounded" } },
        menu = {
          border = "rounded",
          draw = {
            gap = 1,
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },

            components = {
              label = {
                text = function(ctx)
                  -- Make sure that we add a "space" between the `label` & `label_detail`
                  -- if the component kind is not a function/method/constructor/snippet.

                  -- We need to convert to an integer so that we can compare since
                  -- `ctx.kind` is a string like "Method", "Interface", etc.
                  local converted_kind = types.CompletionItemKind[ctx.kind]
                  local label = ctx.label

                  if
                    converted_kind ~= types.CompletionItemKind.Method
                    and converted_kind ~= types.CompletionItemKind.Function
                    and converted_kind ~= types.CompletionItemKind.Constructor
                    and converted_kind ~= types.CompletionItemKind.Snippet
                  then
                    label = label .. " "
                  end

                  return label .. ctx.label_detail
                end,
              },
            },
          },
        },
      },
    })
  end,
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
