local setup_lazy = function()
  if vim.fn.input("Download Lazy.nvim? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format("%s/lazy/lazy.nvim", vim.fn.stdpath("data"))

  vim.fn.mkdir(directory, "p")

  local out = vim.fn.system(vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    directory,
  }))

  print(out)
  print("Downloading lazy.nvim...")
  print("You'll need to restart...")
  vim.cmd([[qa]])
end

local M = {}

function M.check()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })

    return true
  end

  vim.opt.rtp:prepend(lazypath)

  return false
end

return M
