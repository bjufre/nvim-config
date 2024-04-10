local M = {}

M.setup_nextls = function()
  local elixir = require("elixir")
  local elixirls = require("elixir.elixirls")
  local nextls_opts = {
    enable = true,
    init_options = {
      experimental = {
        completions = { enable = true },
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
      enable = false, -- this needs to be enabled until `nextls` works with all the features that this does.
      settings = elixirls.settings({
        mixEnv = "dev",
        fetchDeps = false,
        dialyzerEnabled = true,
        enableTestLenses = false,
      }),
    },
  })
end

M.setup_lexical = function()
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

  configs.lexical.setup({})
end

M.setup = function()
  -- M.setup_nextls()
  M.setup_lexical()
end

return M
