local M = {}

M._virtual_text_handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

M.setup = function()
  local ufo = require("ufo")

  -- Based on: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/quick-recipes.md#enable-folds-with-nvim-ufo
  -- Override the defaults set in `options.lua`
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99 -- Using ofo provider need a large value, feel free to decrease it
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
  vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

  ufo.setup({
    fold_virt_text_handler = M._virtual_text_handler,
    provider_selector = function()
      return { "treesitter", "indent" }
    end,
  })

  require("bjufre.keymaps").register({
    normal_mode = {
      ["fO"] = ufo.openAllFolds,
      ["fC"] = ufo.closeAllFolds,
      ["fo"] = "zo",
      ["fc"] = "zc",
    },
  })
end

return M
