local M = {}

local function is_elixir_project()
  local current_dir = vim.uv.cwd()
  if current_dir == nil then
    return false
  end

  return vim.fs.root(current_dir, "mix.exs") ~= nil
end

local function restart_lsp()
  vim.cmd("silent! lsp restart")
end

local function start_lsp()
  vim.cmd("silent! lsp enable")
end

local function remove_directory(dir_name, description)
  if vim.fn.isdirectory(dir_name) ~= 1 then
    return
  end

  if vim.fn.delete(dir_name, "rf") == 0 then
    vim.notify(string.format("Removed %s", description))
  else
    vim.notify(string.format("Could not remove %s", description), vim.log.levels.WARN)
  end
end

function M.is_diagnostic()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1] - 1 -- Convert to 0-indexed
  local col = cursor_pos[2]

  local diagnostics = vim.diagnostic.get(0, { lnum = row })

  for _, diagnostic in ipairs(diagnostics) do
    local end_col = diagnostic.end_col or diagnostic.col
    if col >= diagnostic.col and col <= end_col then
      return true
    end
  end

  return false
end

function M.restart()
  -- If we're dealing with an Elixir project,
  -- remove the LSP created files too.
  -- Otherwise, just restart the instance.
  if is_elixir_project() then
    vim.schedule(function()
      vim.defer_fn(function()
        -- safe_remove("deps", "Elixir Dependencies")
        -- safe_remove("_build", "Elixir build artifacts")
        remove_directory(".elixir_ls", "Elixir LS cache")
        remove_directory(".elixir-tools", "Elixir tools cache")

        -- Restart LSP after cleanup
        vim.defer_fn(function()
          restart_lsp()
        end, 500)
      end, 1000)
    end)
  else
    vim.schedule(function()
      restart_lsp()
    end)
  end
end

-- Alternative version with even more robust handling
function M.restart_robust()
  if is_elixir_project() then
    vim.schedule(function()
      -- Get all active LSP clients
      local clients = vim.lsp.get_clients()

      -- Stop Elixir-related clients specifically
      for _, client in ipairs(clients) do
        if client.name == "elixirls" or client.name == "nextls" or client.name == "lexical" then
          vim.notify(string.format("Stopping %s LSP client", client.name))
          client:stop()
        end
      end

      vim.defer_fn(function()
        -- Try to remove directories
        remove_directory(".elixir_ls", ".elixir_ls")
        remove_directory(".elixir-tools", ".elixir-tools")

        -- Restart LSP
        vim.defer_fn(function()
          start_lsp()
          vim.notify("LSP restarted")
        end, 1000)
      end, 1500)
    end)
  else
    vim.schedule(function()
      restart_lsp()
    end)
  end
end

return M
