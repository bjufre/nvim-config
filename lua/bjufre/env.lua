local M = {}

local function prepend(path, current_path)
  if path == nil or path == "" then
    return current_path
  end

  for _, segment in ipairs(vim.split(current_path, ":", { trimempty = true })) do
    if segment == path then
      return current_path
    end
  end

  if current_path == "" then
    return path
  end

  return path .. ":" .. current_path
end

function M.prepend_to_path(path)
  vim.env.PATH = prepend(path, vim.env.PATH or "")
end

function M.node_bin_dir()
  local node_path = vim.fn.exepath("node")
  if node_path ~= "" then
    return vim.fs.dirname(node_path)
  end

  local candidates = vim.split(vim.fn.glob(vim.fn.expand("~/.local/share/mise/installs/node/*/bin/node")), "\n", {
    trimempty = true,
  })
  table.sort(candidates)

  local fallback = candidates[#candidates]
  if fallback == nil or fallback == "" then
    return nil
  end

  return vim.fs.dirname(fallback)
end

function M.ensure_node()
  if vim.fn.executable("node") == 1 then
    return
  end

  M.prepend_to_path(M.node_bin_dir())
end

function M.with_node_path(config)
  local dir = M.node_bin_dir()
  if dir == nil then
    return config
  end

  return vim.tbl_deep_extend("force", config, {
    cmd_env = {
      PATH = prepend(dir, vim.env.PATH or ""),
    },
  })
end

return M
