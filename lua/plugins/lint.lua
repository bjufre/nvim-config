return {
  "mfussenegger/nvim-lint",
  enabled = true,
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
}
