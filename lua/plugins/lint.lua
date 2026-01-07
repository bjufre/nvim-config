return {
  "mfussenegger/nvim-lint",
  enabled = true,
  config = function()
    local lint = require("lint")

    -- Helper to check if a config file exists in project root
    local function has_config(files)
      local root = vim.fn.getcwd()
      for _, file in ipairs(files) do
        if vim.fn.filereadable(root .. "/" .. file) == 1 then
          return true
        end
      end
      return false
    end

    local oxlint_configs = { "oxlintrc.json", ".oxlintrc.json", "oxlint.json" }
    local eslint_configs = {
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.json",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
    }

    local js_filetypes = {
      "vue",
      "svelte",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    }

    lint.linters_by_ft = {
      ruby = { "rubocop" },

      elixir = { "credo" },
      heex = { "credo" },
      eelixir = { "credo" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        local ft = vim.bo.filetype

        -- Check if it's a JS filetype and run appropriate linters
        if vim.tbl_contains(js_filetypes, ft) then
          local linters = {}
          if has_config(oxlint_configs) then
            table.insert(linters, "oxlint")
          end
          if has_config(eslint_configs) then
            table.insert(linters, "eslint")
          end
          if #linters > 0 then
            lint.try_lint(linters)
          end
        else
          lint.try_lint()
        end
      end,
    })
  end,
}
