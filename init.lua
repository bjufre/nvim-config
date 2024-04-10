-- Globals
require("bjufre.options")
require("bjufre.autocmds")

-- Set the leader key early in the config so that any other keymaps
-- set by plugins or other files are mapped correctly.
vim.g.mapleader = " "
require("bjufre.keymaps").register_defaults() -- Setup the default keymaps

-- First.register (setup Lazy.nvim)
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
end

vim.opt.runtimepath:prepend(lazypath)

-- Initialize Lazy's plugins
require("lazy").setup("plugins", {
  dev = {
    -- directory where you store your local plugin projects
    path = "~/code",
    fallback = false,
  },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})

-- Set the colorscheme
require("bjufre.colorscheme")
