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

function M.remap(mode, mapping, func, opts)
  vim.keymap.set(mode, mapping, func, vim.tbl_deep_extend("force", {}, generic_opts, opts or {}))
end

function M.register_defaults()
  ------------------------------
  -- Insert Mode
  ------------------------------
  -- remap('i', 'jk', '<ESC>')

  ------------------------------
  -- Normal Mode
  ------------------------------
  M.remap("n", "qq", "<cmd>:q<CR>", { desc = "[Q]uit" })
  M.remap("n", "QQ", "<cmd>:qall<CR>", { desc = "[Q]uit all!" })
  -- Buffer navigation -> Go to the previous buffer edited in the same window
  -- M.remap('n', '<C-,>', '<C-^>') -- Had some issues with Tmux and this binding
  M.remap("n", ",", "<C-^>")
  M.remap("n", "<leader>x", ":Bwipeout<CR>", { desc = "Wipeout buffer" })
  M.remap("n", "<leader>w", ":wa!<CR>", { desc = "[W]rite all!" })
  M.remap("n", "U", "<C-r>")

  -- Keep view centered when scrolling
  M.remap("n", "<C-d>", "<C-d>zz")
  M.remap("n", "<C-u>", "<C-u>zz")

  -- Keep view centered when searching
  M.remap("n", "n", "nzzzv")
  M.remap("n", "N", "Nzzzv")

  -- Better window movement
  M.remap("n", "<C-h>", "<C-w>h", { desc = "[G]o to Left split" })
  M.remap("n", "<C-j>", "<C-w>j", { desc = "[G]o to Lower split" })
  M.remap("n", "<C-k>", "<C-w>k", { desc = "[G]o to Upper split" })
  M.remap("n", "<C-l>", "<C-w>l", { desc = "[G]o to Right split" })
  -- M.remap("n", "<C-v>", "<C-w>v", { desc = "[S]plit [V]ertical" })
  -- M.remap("n", "<C-b>", "<C-w>s", { desc = "[S]plit [B]ottom" })
  -- Tabs navigation
  -- M.remap("n", "<S-Tab>", ":tabprev<CR>", { desc = "[T]ab prev" })
  -- M.remap("n", "<Tab>", ":tabnext<CR>", { desc = "[T]ab next" })

  -- Resize with arrows
  M.remap("n", "<S-Up>", ":resize -2<CR>", { desc = "Resize up" })
  M.remap("n", "<S-Down>", ":resize +2<CR>", { desc = "Resize down" })
  M.remap("n", "<S-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
  M.remap("n", "<S-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
  M.remap("n", "<leader>=", "<C-w>=", { desc = "Resize equalize" }) -- reset panes

  -- Folds (CHANGED IN LSP)
  -- M.remap("n", "fo", "zo")
  -- M.remap("n", "fc", "zc")
  -- M.remap("n", "fO", "zR")

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
