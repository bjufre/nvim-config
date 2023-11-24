local generic_opts = {
  noremap = true,
  silent = true,
}
local modes = {
  normal_mode = "n",
  insert_mode = "i",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  term_mode = "t",
}

local M = {}

function M.remap(mode, mapping, func)
  vim.keymap.set(mode, mapping, func, generic_opts)
end

function M.register_defaults()
  ------------------------------
  -- Insert Mode
  ------------------------------
  -- remap('i', 'jk', '<ESC>')

  ------------------------------
  -- Normal Mode
  ------------------------------
  M.remap("n", "qq", "<cmd>:q<CR>")
  M.remap("n", "QQ", "<cmd>:qall<CR>")
  -- Buffer navigation -> Go to the previous buffer edited in the same window
  -- M.remap('n', '<C-,>', '<C-^>') -- Had some issues with Tmux and this binding
  M.remap("n", ",", "<C-^>")
  M.remap("n", "<leader>x", ":Bwipeout<CR>")
  M.remap("n", "<leader>w", ":wa!<CR>")
  M.remap("n", "U", "<C-r>")

  -- Better Joining lines
  -- M.remap('n', 'J', 'mzJ`z')

  -- Keep view centered when scrolling
  M.remap("n", "<C-d>", "<C-d>zz")
  M.remap("n", "<C-u>", "<C-u>zz")

  -- Keep view centered when searching
  M.remap("n", "n", "nzzzv")
  M.remap("n", "N", "Nzzzv")

  -- Better window movement
  M.remap("n", "<C-h>", "<C-w>h")
  M.remap("n", "sh", "<C-w>h")
  M.remap("n", "sj", "<C-w>j")
  M.remap("n", "sk", "<C-w>k")
  M.remap("n", "sl", "<C-w>l")
  M.remap("n", "sv", "<C-w>v")
  M.remap("n", "sb", "<C-w>s")
  -- Tabs navigation
  -- M.remap('n', '<S-Tab>', ':tabprev<CR>')
  -- M.remap('n', '<Tab>', ':tabnext<CR>')

  -- Resize with arrows
  M.remap("n", "<S-Up>", ":resize -2<CR>")
  M.remap("n", "<S-Down>", ":resize +2<CR>")
  M.remap("n", "<S-Left>", ":vertical resize -2<CR>")
  M.remap("n", "<S-Right>", ":vertical resize +2<CR>")
  M.remap("n", "<leader>=", "<C-w>=") -- reset panes

  -- Folds
  M.remap("n", "fo", "zo")
  M.remap("n", "fc", "zc")
  M.remap("n", "fO", "zR")

  ------------------------------
  -- Visual Mode
  ------------------------------
  -- Better indenting
  M.remap("v", "<", "<gv")
  M.remap("v", ">", ">gv")
  -- Move current line / block with Alt-j/k a la vscode.
  M.remap("v", "J", ":m '>+1<CR>gv=gv")
  M.remap("v", "K", ":m '<-2<CR>gv=gv")

  ------------------------------
  -- Insert Mode
  ------------------------------
  M.remap("i", "jk", "<ESC>")
end

function M.register(keymaps)
  for mode, mode_keymaps in pairs(keymaps) do
    local mode_adapter = modes[mode]

    for key, value in pairs(mode_keymaps) do
      if type(value) == "table" then
        value = value[1]
      end

      if value then
        M.remap(mode_adapter, key, value)
      end
    end
  end
end

return M
