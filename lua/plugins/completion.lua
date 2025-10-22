return {
  "saghen/blink.cmp",
  -- optional: provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "1.*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = { preset = "default" },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
      kind_icons = require("bjufre.icons").kind,
    },

    completion = {
      keyword = {
        range = "prefix",
      },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      accept = {
        auto_brackets = {
          enabled = true,
          default_brackets = { "(", ")", "[", "]", "{", "}" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          max_width = 80,
          max_height = 20,
        },
      },
      menu = {
        border = "rounded",
        auto_show = true,
        draw = {
          gap = 1,
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                -- Simplified label formatting for better performance
                local label = ctx.label
                local converted_kind = require("blink.cmp.types").CompletionItemKind[ctx.kind]

                -- Only add space for non-function types
                if
                  converted_kind ~= require("blink.cmp.types").CompletionItemKind.Method
                  and converted_kind ~= require("blink.cmp.types").CompletionItemKind.Function
                  and converted_kind ~= require("blink.cmp.types").CompletionItemKind.Constructor
                  and converted_kind ~= require("blink.cmp.types").CompletionItemKind.Snippet
                then
                  label = label .. " "
                end

                return label .. (ctx.label_description or "")
              end,
            },
          },
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
        max_items = 40,
      },
      ghost_text = {
        enabled = true,
        show_with_menu = true,
        show_without_selection = false,
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = { implementation = "prefer_rust_with_warning" },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          fallbacks = { "buffer" },
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = -3,
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = -5,
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = -10,
          opts = {
            max_items = 5,
          },
        },
      },
    },

    -- experimental signature help support
    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  },
  opts_extend = { "sources.default" },
}
