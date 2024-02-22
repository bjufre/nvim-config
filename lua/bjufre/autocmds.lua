local augroup = vim.api.nvim_create_augroup
local BHGroup = augroup("BH", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

-- Nice little highlight for yanked text
autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 60,
    })
  end,
})

-- Remove whitespace at the end of lines
autocmd({ "BufWritePre" }, {
  group = BHGroup,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Some useful formatting options so that we make our lifes easier
-- We need to put it in an autocmd because some plugin overwrites it...
autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "*",
  group = augroup("_format-options", {}),
  callback = function()
    -- - 'a' -- Don't autoformat please
    -- - 't' -- Don't autoformat
    -- + 'c' -- Comments respect text width
    -- + 'q' -- Allow formatting comments with gq
    -- - 'o' -- O and o, don't continue comments
    -- + 'r' -- But continue when using enter
    -- + 'n' -- Indent past the formatlistpat, not underneeth it
    -- + 'j' -- Auto-remove comments if possible
    -- - '2' -- We're not in gradeschool anymore
    vim.cmd([[setlocal fo-=a fo-=t fo+=c fo+=q fo-=o fo+=r fo+=n fo-=2]])
    -- vim.cmd [[setlocal fo-=cro]]
  end,
})

autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.slim",
  command = [[setlocal filetype=slim]],
})

autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "*.heex",
  command = [[set syntax=eelixir]],
})

autocmd({ "BufEnter", "BufRead", "BufNewFile" }, {
  pattern = "*.kdl",
  command = [[set syntax=kdl]],
})
