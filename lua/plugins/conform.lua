return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local js_formatters = { "eslint", "prettier" }

    require("conform").setup({
      format_on_save = {
        timeout = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        gleam = { "gleam" },

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
  end,
}
