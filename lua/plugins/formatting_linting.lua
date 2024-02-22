return {
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    events = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        vue = { "eslint" },
        svelte = { "eslint" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescript = { "eslint" },
        typescriptreact = { "eslint" },

        ruby = { "rubocop" },

        -- elixir = { "credo" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
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
  },
}
