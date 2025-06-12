local M = {}

function M.is_diagnostic()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1] - 1 -- Convert to 0-indexed
  local col = cursor_pos[2]

  local diagnostics = vim.diagnostic.get(0, { lnum = row })

  for _, diagnostic in ipairs(diagnostics) do
    if col >= diagnostic.col and col <= diagnostic.end_col then
      return true
    end
  end

  return false
end

function M.restart()
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

    vim.schedule(function()
      vim.defer_fn(function()
        local function safe_remove(path_str, description)
          local path = Path:new(path_str)
          if path:exists() then
            local success, err = pcall(function()
              path:rm({ recursive = true })
            end)

            if not success then
              vim.notify(
                string.format("Warning: Could not remove %s (%s): %s", description, path_str, err),
                vim.log.levels.WARN
              )

              local result = vim.fn.system(string.format("rm -rf %s", vim.fn.shellescape(path_str)))
              if vim.v.shell_error ~= 0 then
                vim.notify(
                  string.format("Failed to remove %s with system command: %s", description, result),
                  vim.log.levels.ERROR
                )
              else
                vim.notify(string.format("Successfully removed %s using system command", description))
              end
            else
              vim.notify(string.format("Successfully removed %s", description))
            end
          end
        end

        -- safe_remove("deps", "Elixir Dependencies")
        -- safe_remove("_build", "Elixir build artifacts")
        safe_remove(".elixir_ls", "Elixir LS cache")
        safe_remove(".elixir-tools", "Elixir tools cache")

        -- Restart LSP after cleanup
        vim.defer_fn(function()
          vim.cmd([[:LspRestart]])
        end, 500)
      end, 1000)
    end)
  else
    vim.schedule(function()
      vim.cmd([[:LspRestart]])
    end)
  end
end

-- Alternative version with even more robust handling
function M.restart_robust()
  if not pcall(require, "lspconfig") then
    return
  end

  if not pcall(require, "plenary") then
    return
  end

  if require("lspconfig.util").root_pattern("mix.exs")(vim.loop.cwd()) then
    vim.schedule(function()
      -- Get all active LSP clients
      local clients = vim.lsp.get_active_clients()

      -- Stop Elixir-related clients specifically
      for _, client in ipairs(clients) do
        if client.name == "elixirls" or client.name == "nextls" or client.name == "lexical" then
          vim.notify(string.format("Stopping %s LSP client", client.name))
          client.stop()
        end
      end

      vim.defer_fn(function()
        -- Try to remove directories
        local function remove_directory(dir_name)
          local handle = vim.loop.fs_scandir(dir_name)
          if handle then
            -- Directory exists, try to remove it
            local cmd = string.format("rm -rf %s", vim.fn.shellescape(dir_name))
            local result = vim.fn.system(cmd)

            if vim.v.shell_error == 0 then
              vim.notify(string.format("Removed %s", dir_name))
            else
              vim.notify(string.format("Could not remove %s: %s", dir_name, result), vim.log.levels.WARN)
            end
          end
        end

        remove_directory(".elixir_ls")
        remove_directory(".elixir-tools")

        -- Restart LSP
        vim.defer_fn(function()
          vim.cmd([[:LspStart]])
          vim.notify("LSP restarted")
        end, 1000)
      end, 1500)
    end)
  else
    vim.schedule(function()
      vim.cmd([[:LspRestart]])
    end)
  end
end

return M
