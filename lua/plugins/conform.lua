return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local js_formatters = { "eslint", "prettier" }

    require("conform").setup({
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end

        -- Do not ad timeout to Ruby files since Rubocop might take a while...
        if vim.b[bufnr].filetype == "ruby" then
          return { lsp_fallback = true }
        end

        return { timeout_ms = 1000, lsp_fallback = true }
      end,
      formatters = {
        rubocop = {
          args = {
            -- "--server",
            "--auto-correct-all",
            "--stderr",
            "--force-exclusion",
            "--stdin",
            "$FILENAME",
          },
        },
      },
      formatters_by_ft = {
        gleam = { "gleam" },

        lua = { "stylua" },
        toml = { "taplo" },
        ruby = { "rubocop" },
        eruby = { "erb-formatter" },

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

    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })
    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
