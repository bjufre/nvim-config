return function()
  if not pcall(require, "lspconfig") then
    return
  end

  if not pcall(require, "plenary") then
    return
  end

  -- If we're dealing with an Elixir project,
  -- remove the LSP created files too.
  -- Otherwise, just restart the instance.
  if require("lspconfig.util").root_pattern("mix.exs")(vim.loop.cwd()) then
    local Path = require("plenary.path")

    Path:new(".elixir_ls"):rm({ recursive = true })
    Path:new(".elixir-tools"):rm({ recursive = true })

    -- Path:new("deps"):rm({ recursive = true })
    -- Path:new("_build"):rm({ recursive = true })

    -- Run `mix do deps.get, deps.compile` async
    vim.schedule(function()
      -- vim.cmd([[:Mix deps.get]])
      -- vim.cmd([[:Mix deps.compile]])
      vim.cmd([[:LspRestart]])
    end)
  else
    vim.schedule(function()
      vim.cmd([[:LspRestart]])
    end)
  end
end
