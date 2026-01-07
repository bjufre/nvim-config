-- Custom tabline function
function _G.custom_tabline()
  local s = ""
  local tab_count = vim.fn.tabpagenr("$")

  for i = 1, tab_count do
    local winnr = vim.fn.tabpagewinnr(i)
    local bufnr = vim.fn.tabpagebuflist(i)[winnr]
    local bufname = vim.fn.bufname(bufnr)

    -- Highlight for active/inactive tabs
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- Tab number
    s = s .. " " .. i .. " "

    -- File name logic
    if bufname == "" then
      s = s .. "[No Name]"
    else
      local filename = vim.fn.fnamemodify(bufname, ":t")

      if tab_count > 1 then
        -- Show parent directory + filename
        local parent = vim.fn.fnamemodify(bufname, ":h:t")
        if parent ~= "" and parent ~= "." then
          s = s .. parent .. "/" .. filename
        else
          s = s .. filename
        end
      else
        -- Just show filename
        s = s .. filename
      end
    end

    -- Modified flag
    if vim.fn.getbufvar(bufnr, "&modified") == 1 then
      s = s .. " [+]"
    end

    s = s .. " "
  end

  -- Fill the rest of the tabline
  s = s .. "%#TabLineFill#%T"

  return s
end

-- Set the tabline
vim.o.tabline = "%!v:lua.custom_tabline()"
