-- Globals
require('bjufre.globals')
require('bjufre.options')

-- First.register (setup Lazy.nvim)
if require('bjufre.first_load').check() then
  return
end

-- Set the leader key early in the config so that any other keymaps
-- set by plugins or other files are mapped correctly.
vim.g.mapleader = ' '
require('bjufre.keymaps').register_defaults() -- Setup the default keymaps

-- Initialize Lazy's plugins
require('bjufre.plugins')

require('bjufre.autocmds')
require('bjufre.colorscheme')
