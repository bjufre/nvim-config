local M = {}

M.setup = function(on_attach)
  local elixir = require("elixir")
  local elixirls = require("elixir.elixirls")
  local elixir_on_attach = function(client, bufnr)
    local opts = { buffer = true, noremap = true }

    on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<CR>", opts)
    vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<CR>", opts)
    vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<CR>", opts)
  end

  elixir.setup({
    nextls = {
      enable = true,
      cmd = "/Users/bj/.local/share/nvim/mason/bin/nextls",
      on_attach = elixir_on_attach,
      init_options = {
        experimental = {
          completions = { enable = false },
        },
      },
    },
    credo = {
      enable = true,
    },
    elixirls = {
      cmd = "/Users/bj/.local/share/nvim/mason/bin/elixir-ls",
      enable = true, -- this needs to be enabled until `nextls` works with all the features that this does.
      settings = elixirls.settings({
        fecthDeps = true,
        dialyzerEnabled = true,
        enableTestLenses = false,
      }),
      on_attach = elixir_on_attach,
    },
  })
end

return M
