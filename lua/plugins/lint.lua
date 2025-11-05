return {
  "mfussenegger/nvim-lint",
  enabled = true,
  config = function()
    local lint = require("lint")
    -- local js_linters = { "oxlint", "eslint" }
    local js_linters = { "eslint" }

    lint.linters_by_ft = {
      vue = js_linters,
      svelte = js_linters,
      javascript = js_linters,
      javascriptreact = js_linters,
      typescript = js_linters,
      typescriptreact = js_linters,

      ruby = { "rubocop" },

      elixir = { "credo" },
      heex = { "credo" },
      eelixir = { "credo" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
