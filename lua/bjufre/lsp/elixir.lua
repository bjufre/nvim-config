local M = {}

local elixir_on_attach = function(on_attach)
  return function(client, bufnr)
    local opts = { buffer = true, noremap = true }

    on_attach(client, bufnr)
    vim.keymap.set("n", "<leader>fp", ":ElixirFromPipe<CR>", opts)
    vim.keymap.set("n", "<leader>tp", ":ElixirToPipe<CR>", opts)
    vim.keymap.set("v", "<leader>em", ":ElixirExpandMacro<CR>", opts)
  end
end

M.setup_nextls = function(on_attach)
  local elixir = require("elixir")
  local elixirls = require("elixir.elixirls")
  local attach_fn = elixir_on_attach(on_attach)
  local nextls_opts = {
    enable = true,
    on_attach = attach_fn,
    init_options = {
      experimental = {
        completions = { enable = false },
      },
    },
  }

  if vim.env.NEXT_LS_LOCAL then
    vim.tbl_deep_extend("force", nextls_opts, {
      port = 9000,
    })
  else
    vim.tbl_deep_extend("force", nextls_opts, {
      cmd = "/Users/bj/.local/share/nvim/mason/bin/nextls",
    })
  end

  elixir.setup({
    nextls = nextls_opts,
    credo = { enable = false },
    elixirls = {
      cmd = "/Users/bj/.local/share/nvim/mason/bin/elixir-ls",
      enable = true, -- this needs to be enabled until `nextls` works with all the features that this does.
      settings = elixirls.settings({
        mixEnv = "dev",
        fetchDeps = false,
        dialyzerEnabled = true,
        enableTestLenses = false,
      }),
      on_attach = attach_fn,
    },
  })
end

M.setup_lexical = function(on_attach)
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")

  local lexical_config = {
    filetypes = { "elixir", "eelixir", "heex" },
    cmd = { "/Users/bj/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
    settings = {},
  }

  if not configs.lexical then
    configs.lexical = {
      default_config = {
        filetypes = lexical_config.filetypes,
        cmd = lexical_config.cmd,
        root_dir = function(fname)
          return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
        end,
        -- Optional settings
        settings = lexical_config.settings,
      },
    }
  end

  configs.lexical.setup({
    on_attach = elixir_on_attach(on_attach),
  })
end

M.setup = function(on_attach)
  M.setup_nextls(on_attach)
  -- M.setup_lexical(on_attach)
end

return M
